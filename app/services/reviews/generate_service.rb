module Reviews
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

      review.update!(
        status: 'completed',
        summary: result[:content],
        review_content: result[:content],
        tokens_used: result[:tokens_used],
        latency_ms: elapsed_milliseconds(started_at),
        reviewed_at: Time.current,
        error_message: nil
      )

      review
    rescue StandardError => e
      review&.update!(status: 'failed', error_message: e.message)
      raise
    end

    private

    attr_reader :pull_request

    def find_or_initialize_review(ai_model)
      pull_request.reviews.find_or_initialize_by(commit_sha: pull_request.head_commit_sha, ai_model: ai_model)
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

        Return only the issues found.

        Pull request: #{pull_request.title}

        Changes:
        #{changes}
      PROMPT
    end

    def elapsed_milliseconds(started_at)
      ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    end
  end
end
