module Reviews
  class Generate
    def self.call(pull_request)
      ai_model = pull_request.repository.ai_model || AiModel.find_by!(is_default: true, active: true)
      review = find_or_initialize_review(pull_request, ai_model)

      return review if review.persisted? && review.status == 'completed'

      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      files = Github::FetchPullRequestDiff.call(pull_request)
      result = Ai::Providers::Gemini.call(model: ai_model.slug, prompt: build_prompt(pull_request, files))
      latency_ms = elapsed_milliseconds(started_at)

      review.update!(
        status: 'completed',
        summary: result[:content],
        review_content: result[:content],
        tokens_used: result[:tokens_used],
        latency_ms: latency_ms,
        reviewed_at: Time.current,
        error_message: nil
      )

      review
    rescue StandardError => e
      review&.update!(status: 'failed', error_message: e.message)
      raise
    end

    def self.find_or_initialize_review(pull_request, ai_model)
      pull_request.reviews.find_or_initialize_by(commit_sha: pull_request.head_commit_sha, ai_model: ai_model)
    end

    def self.build_prompt(pull_request, files)
      formatted_files = files.map do |file|
        patch = file[:patch].presence || 'Binary file or patch not available. Do not review or guess the file content. Only note the filename and change status.'

        <<~FILE
          File: #{file[:filename]}
          Status: #{file[:status]}
          Additions: #{file[:additions]}
          Deletions: #{file[:deletions]}
          Patch:
          #{patch}
        FILE
      end.join("\n")

      <<~PROMPT
        Review the code changes in this pull request.

        Pull request: #{pull_request.title}
        Source branch: #{pull_request.source_branch}
        Target branch: #{pull_request.target_branch}

        Review rules:
        - Check for bugs, security risks, incorrect logic and maintainability issues.
        - Do not guess code that is not included in the patch.
        - If a file is binary or its patch is unavailable, only mention its filename and change status.
        - Do not report an issue based only on a binary file name.

        Return:
        1. Summary
        2. Issues found
        3. Suggested improvements

        Changes:
        #{formatted_files}
      PROMPT
    end

    def self.elapsed_milliseconds(started_at)
      finished_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      ((finished_at - started_at) * 1000).round
    end

    private_class_method :find_or_initialize_review
    private_class_method :build_prompt
    private_class_method :elapsed_milliseconds
  end
end
