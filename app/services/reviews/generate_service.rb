module Reviews
  class GenerateService < ApplicationService
    def initialize(review)
      @review = review
    end

    def call
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      files = Github::FetchPullRequestDiffService.call(pull_request, base_sha: review.base_commit_sha, head_sha: review.commit_sha)
      result = Ai::Providers::GeminiService.call(model: review.ai_model.slug, prompt: build_prompt(files))

      summary, review_content = parse_response(result[:content])

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
    end

    private

    attr_reader :review

    def pull_request
      @pull_request ||= review.pull_request
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

    def parse_response(content)
      summary = content[/## Summary\s*(.*?)(?=## Review|\z)/m, 1]&.strip
      review_content = content[/## Review\s*(.*)\z/m, 1]&.strip

      [summary.presence || 'Review completed.', review_content.presence || content]
    end

    def count_issues(content)
      content.scan(/^### Issue/).count
    end

    def elapsed_milliseconds(started_at)
      ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    end
  end
end
