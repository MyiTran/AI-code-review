module Reviews
<<<<<<< HEAD:app/services/reviews/generate_service.rb
  class GenerateService < ApplicationService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ai_model = pull_request.repository.ai_model || AiModel.find_by!(is_default: true, active: true)
      review = find_or_initialize_review(ai_model)

      return review if review.persisted? && review.status == 'completed'

      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      files = Github::FetchPullRequestDiffService.call(pull_request)
      result = Ai::Providers::GeminiService.call(model: ai_model.slug, prompt: build_prompt(files))
=======
  class Generate
    def self.call(review)
      pull_request = review.pull_request
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      files = Github::FetchPullRequestDiff.call(pull_request, base_sha: review.base_commit_sha, head_sha: review.commit_sha)
      result = Ai::Providers::Gemini.call(model: review.ai_model.slug, prompt: build_prompt(pull_request, files))

      summary, review_content = parse_response(result[:content])
>>>>>>> 6056129 (feat: add comment review by AI on pull request):app/services/reviews/generate.rb

      review.update!(
        status: 'completed',
        summary: summary,
        review_content: review_content,
        issues_found_count: count_issues(review_content),
        tokens_used: result[:tokens_used],
        latency_ms: elapsed_milliseconds(started_at),
        reviewed_at: Time.current,
        error_message: nil
      )

      review
<<<<<<< HEAD:app/services/reviews/generate_service.rb
    rescue StandardError => e
      review&.update!(status: 'failed', error_message: e.message)
      raise
    end

    private

    attr_reader :pull_request

    def find_or_initialize_review(ai_model)
      pull_request.reviews.find_or_initialize_by(commit_sha: pull_request.head_commit_sha, ai_model: ai_model)
=======
>>>>>>> 6056129 (feat: add comment review by AI on pull request):app/services/reviews/generate.rb
    end

    def build_prompt(files)
      changes = files.map do |file|
        patch = file[:patch].presence || 'Binary file or patch not available.'

        <<~FILE
          File: #{file[:filename]}
          #{patch}
        FILE
      end.join("\n")

      <<~PROMPT
        Review this pull request and find bugs or incorrect logic.

        Do not guess missing code.
        Ignore binary files.

        Return markdown using exactly this format:

        ## Summary
        Write one short sentence summarizing the result.

        ## Review
        For each issue, use:

        ### Issue 1

        - File:
        - Problem:
        - Suggestion:

        ### Issue 2

        ...

        ### Issue 3

        ...

        If there are no issues, return:

        ## Summary
        No issues detected.

        ## Review
        No issues found.

        Pull request: #{pull_request.title}

        Changes:
        #{changes}
      PROMPT
    end

<<<<<<< HEAD:app/services/reviews/generate_service.rb
    def elapsed_milliseconds(started_at)
      ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    end
=======
    def self.parse_response(content)
      summary = content[/## Summary\s*(.*?)(?=## Review|\z)/m, 1]&.strip
      review_content = content[/## Review\s*(.*)\z/m, 1]&.strip

      [summary.presence || 'Review completed.', review_content.presence || content]
    end

    def self.count_issues(content)
      content.scan(/^### Issue/).count
    end

    def self.elapsed_milliseconds(started_at)
      ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    end

    private_class_method :build_prompt, :parse_response, :count_issues, :elapsed_milliseconds
>>>>>>> 6056129 (feat: add comment review by AI on pull request):app/services/reviews/generate.rb
  end
end
