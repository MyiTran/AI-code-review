module Github
  class CreatePullRequestComment
    def self.call(review)
      return review if review.github_comment_id.present?

      pull_request = review.pull_request
      repository = pull_request.repository
      token = Github::InstallationToken.call(repository.github_installation.installation_id)
      client = Octokit::Client.new(access_token: token)
      comment = client.add_comment(repository.full_name, pull_request.number, comment_body(review))

      review.update!(
        github_comment_id: comment.id,
        commented_at: Time.current
      )

      review
    end

    def self.comment_body(review)
      <<~COMMENT
        ## AI Code Review

        #{review.review_content}
      COMMENT
    end

    private_class_method :comment_body
  end
end
