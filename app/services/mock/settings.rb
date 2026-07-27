module Mock
  class Settings
    def self.data
      {
        profile: {
          name: "Hazel Tran",
          github_username: "MyiTran",
          email: "hazel_tr@example.com",
          initials: "HT"
        },

        review: {
          default_model: "Gemini 2.5 Flash",
          auto_review_enabled: true,
          review_drafts: false,
          review_on_push: true,
          include_suggestions: true,
          severity_threshold: "Suggestion",
          maximum_files: 50
        },

        notifications: {
          email_completed_reviews: true,
          email_failed_reviews: true,
          email_weekly_summary: false,
          github_comments: true
        },

        github: {
          account: "MyiTran",
          installation_status: "Connected",
          connected_at: "July 15, 2026",
          repositories_count: 5
        },

        billing: {
          plan: "Free",
          reviews_used: 24,
          reviews_limit: 50,
          renewal_date: "August 1, 2026"
        }
      }
    end
  end
end