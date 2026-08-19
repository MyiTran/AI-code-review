module Github
  class CreatePullRequestCommentService < ApplicationService
    def initialize(review)
      @review = review
    end

    def call
      return review if review.github_comment_id.present?

      pull_request = review.pull_request
      repository = pull_request.repository
      token = Github::GenerateInstallationTokenService.call(repository.github_installation.installation_id)
      client = Octokit::Client.new(access_token: token)
      comment = client.add_comment(repository.full_name, pull_request.number, comment_body)

      review.update!(
        github_comment_id: comment.id,
        commented_at: Time.current
      )

      review
    end

    private

    attr_reader :review

    def comment_body
      <<~COMMENT
        ## AI Code Review

        #{review.review_content}
      COMMENT
    end
  end
end
