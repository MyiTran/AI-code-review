module Mock
  class Repositories
    DATA = [
      {
        id: 1,
        user_id: 1,
        name: "ai-code-review-github",
        full_name: "MyiTran/ai-code-review-github",
        description: "AI-powered code review service built with Ruby on Rails.",
        language: "Ruby",
        visibility: "Private",
        connection_status: "Connected",
        auto_review_enabled: true,
        ai_model: "Gemini 2.5 Flash",
        default_branch: "main",
        pull_requests_count: 32,
        ai_reviews_count: 24,
        issues_found_count: 61,
        contributors_count: 4,
        last_reviewed_at: "5 minutes ago",
        connected_at: "July 15, 2026",
        github_url: "https://github.com/MyiTran/ai-code-review-github",

        review_history: [
          {
            id: 101,
            pull_request_number: 42,
            title: "Add GitHub webhook handler",
            source_branch: "feature/github-webhook",
            target_branch: "main",
            author: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            issues_found: 6,
            status: "Completed",
            reviewed_at: "10 minutes ago"
          },
          {
            id: 102,
            pull_request_number: 39,
            title: "Create repository dashboard",
            source_branch: "feature/repository-dashboard",
            target_branch: "main",
            author: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            issues_found: 3,
            status: "Completed",
            reviewed_at: "2 hours ago"
          },
          {
            id: 103,
            pull_request_number: 37,
            title: "Configure Sidekiq workers",
            source_branch: "feature/sidekiq",
            target_branch: "main",
            author: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            issues_found: 0,
            status: "Processing",
            reviewed_at: "Yesterday"
          }
        ]
      },

      {
        id: 2,
        user_id: 1,
        name: "darling-web",
        full_name: "MyiTran/darling-web",
        description: "Playwright automation and visual testing project.",
        language: "TypeScript",
        visibility: "Private",
        connection_status: "Connected",
        auto_review_enabled: true,
        ai_model: "Claude Sonnet",
        default_branch: "develop",
        pull_requests_count: 48,
        ai_reviews_count: 18,
        issues_found_count: 39,
        contributors_count: 8,
        last_reviewed_at: "2 hours ago",
        connected_at: "July 10, 2026",
        github_url: "https://github.com/MyiTran/darling-web",

        review_history: [
          {
            id: 201,
            pull_request_number: 318,
            title: "Fix navigation highlight",
            source_branch: "fix/navigation-highlight",
            target_branch: "develop",
            author: "Developer One",
            model: "Claude Sonnet",
            issues_found: 3,
            status: "Completed",
            reviewed_at: "1 hour ago"
          },
          {
            id: 202,
            pull_request_number: 315,
            title: "Add intranet visual tests",
            source_branch: "feature/intranet-visual",
            target_branch: "develop",
            author: "Developer Two",
            model: "Claude Sonnet",
            issues_found: 2,
            status: "Completed",
            reviewed_at: "Yesterday"
          }
        ]
      },

      {
        id: 3,
        user_id: 1,
        name: "rails-learning",
        full_name: "MyiTran/rails-learning",
        description: "Ruby on Rails learning exercises and examples.",
        language: "Ruby",
        visibility: "Public",
        connection_status: "Connected",
        auto_review_enabled: false,
        ai_model: "GPT-4.1 Mini",
        default_branch: "main",
        pull_requests_count: 15,
        ai_reviews_count: 9,
        issues_found_count: 17,
        contributors_count: 1,
        last_reviewed_at: "Yesterday",
        connected_at: "July 2, 2026",
        github_url: "https://github.com/MyiTran/rails-learning",

        review_history: [
          {
            id: 301,
            pull_request_number: 15,
            title: "Add repository model",
            source_branch: "feature/repository-model",
            target_branch: "main",
            author: "Hazel Tran",
            model: "GPT-4.1 Mini",
            issues_found: 0,
            status: "Completed",
            reviewed_at: "Yesterday"
          }
        ]
      },

      {
        id: 4,
        user_id: 1,
        name: "portfolio",
        full_name: "MyiTran/portfolio",
        description: "Personal portfolio and professional experience.",
        language: "HTML",
        visibility: "Public",
        connection_status: "Connected",
        auto_review_enabled: true,
        ai_model: "Gemini 2.5 Flash",
        default_branch: "main",
        pull_requests_count: 7,
        ai_reviews_count: 6,
        issues_found_count: 8,
        contributors_count: 1,
        last_reviewed_at: "3 days ago",
        connected_at: "June 28, 2026",
        github_url: "https://github.com/MyiTran/portfolio",

        review_history: [
          {
            id: 401,
            pull_request_number: 7,
            title: "Update work experience section",
            source_branch: "feature/update-experience",
            target_branch: "main",
            author: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            issues_found: 1,
            status: "Completed",
            reviewed_at: "3 days ago"
          }
        ]
      },

      {
        id: 5,
        user_id: 1,
        name: "sample-react-app",
        full_name: "MyiTran/sample-react-app",
        description: "Example React application for frontend experiments.",
        language: "JavaScript",
        visibility: "Private",
        connection_status: "Disconnected",
        auto_review_enabled: false,
        ai_model: nil,
        default_branch: "main",
        pull_requests_count: 12,
        ai_reviews_count: 4,
        issues_found_count: 11,
        contributors_count: 2,
        last_reviewed_at: "1 week ago",
        connected_at: "June 20, 2026",
        github_url: "https://github.com/MyiTran/sample-react-app",
        review_history: []
      }
    ].freeze

    def self.all
      DATA
    end

    def self.find(id)
      DATA.find do |repository|
        repository[:id].to_s == id.to_s
      end
    end
  end
end