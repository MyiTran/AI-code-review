module Mock
  class AdminDashboard
    def self.data
      {
        stats: [
          {
            label: "Total users",
            value: 1_284,
            change: "+12.4%",
            trend: "up",
            icon: "bi-people",
            style: "primary"
          },
          {
            label: "Connected repositories",
            value: 3_841,
            change: "+8.2%",
            trend: "up",
            icon: "bi-github",
            style: "success"
          },
          {
            label: "AI reviews this month",
            value: 18_492,
            change: "+24.6%",
            trend: "up",
            icon: "bi-stars",
            style: "purple"
          },
          {
            label: "Failed reviews",
            value: 73,
            change: "-4.1%",
            trend: "down",
            icon: "bi-exclamation-triangle",
            style: "danger"
          }
        ],

        system: {
          status: "Operational",
          uptime: "99.98%",
          queue_size: 18,
          average_review_time: "21 sec",
          webhook_success_rate: "99.4%"
        },

        usage: [
          { month: "Feb", reviews: 8_900 },
          { month: "Mar", reviews: 10_800 },
          { month: "Apr", reviews: 12_500 },
          { month: "May", reviews: 14_300 },
          { month: "Jun", reviews: 15_900 },
          { month: "Jul", reviews: 18_492 }
        ],

        users: [
          {
            id: 1,
            name: "Hazel Tran",
            email: "hazel_tr@example.com",
            initials: "HT",
            plan: "Free",
            repositories: 5,
            reviews: 24,
            status: "Active",
            joined_at: "Jul 15, 2026"
          },
          {
            id: 2,
            name: "Alex Morgan",
            email: "alex@example.com",
            initials: "AM",
            plan: "Pro",
            repositories: 18,
            reviews: 426,
            status: "Active",
            joined_at: "Jul 12, 2026"
          },
          {
            id: 3,
            name: "Jordan Lee",
            email: "jordan@example.com",
            initials: "JL",
            plan: "Team",
            repositories: 42,
            reviews: 1_208,
            status: "Active",
            joined_at: "Jul 10, 2026"
          },
          {
            id: 4,
            name: "Taylor Kim",
            email: "taylor@example.com",
            initials: "TK",
            plan: "Free",
            repositories: 2,
            reviews: 8,
            status: "Suspended",
            joined_at: "Jul 8, 2026"
          },
          {
            id: 5,
            name: "Sam Wilson",
            email: "sam@example.com",
            initials: "SW",
            plan: "Pro",
            repositories: 11,
            reviews: 294,
            status: "Active",
            joined_at: "Jul 5, 2026"
          }
        ],

        recent_reviews: [
          {
            id: 101,
            repository: "MyiTran/ai-code-review-github",
            pull_request: "#42 Add GitHub webhook handler",
            user: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            status: "Completed",
            duration: "18 sec",
            created_at: "10 minutes ago"
          },
          {
            id: 201,
            repository: "MyiTran/darling-web",
            pull_request: "#318 Fix navigation highlight",
            user: "Developer One",
            model: "Claude Sonnet",
            status: "Completed",
            duration: "14 sec",
            created_at: "1 hour ago"
          },
          {
            id: 501,
            repository: "MyiTran/ai-code-review-github",
            pull_request: "#44 Add background review job",
            user: "Hazel Tran",
            model: "Gemini 2.5 Flash",
            status: "Processing",
            duration: "Running",
            created_at: "Just now"
          }
        ],

        activities: [
          {
            icon: "bi-person-plus",
            title: "New user registered",
            description: "alex@example.com created a Pro account.",
            time: "8 minutes ago",
            style: "primary"
          },
          {
            icon: "bi-github",
            title: "GitHub installation connected",
            description: "12 repositories were added by Jordan Lee.",
            time: "32 minutes ago",
            style: "dark"
          },
          {
            icon: "bi-exclamation-triangle",
            title: "Review job failed",
            description: "A review failed due to an AI provider timeout.",
            time: "1 hour ago",
            style: "danger"
          },
          {
            icon: "bi-credit-card",
            title: "Plan upgraded",
            description: "Sam Wilson upgraded from Free to Pro.",
            time: "3 hours ago",
            style: "success"
          }
        ]
      }
    end
  end
end