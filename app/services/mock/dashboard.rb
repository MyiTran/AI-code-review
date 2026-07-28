module Mock
  class Dashboard
    def self.call
      {

        stats: [
          {
            label: 'Repositories',
            value: 12,
            icon: 'bi-github',
            change: '+2 this month',
            style: 'primary'
          },
          {
            label: 'Pull Requests',
            value: 68,
            icon: 'bi-git',
            change: '+12 this month',
            style: 'success'
          },
          {
            label: 'AI Reviews',
            value: 51,
            icon: 'bi-stars',
            change: '75% review rate',
            style: 'warning'
          },
          {
            label: 'Issues Found',
            value: 134,
            icon: 'bi-bug',
            change: '24 critical issues',
            style: 'danger'
          }
        ],

        usage: {
          used: 51,
          limit: 100,
          percentage: 51
        },

        repositories: [
          {
            name: 'ai-code-review-github',
            language: 'Ruby',
            reviews: 24,
            status: 'Active',
            updated_at: '5 minutes ago'
          },
          {
            name: 'darling-web',
            language: 'TypeScript',
            reviews: 18,
            status: 'Active',
            updated_at: '2 hours ago'
          },
          {
            name: 'rails-learning',
            language: 'Ruby',
            reviews: 9,
            status: 'Paused',
            updated_at: 'Yesterday'
          }
        ],

        recent_reviews: [
          {
            repository: 'ai-code-review-github',
            pull_request: '#42 Add GitHub webhook handler',
            issues: 6,
            status: 'Completed',
            created_at: '10 minutes ago'
          },
          {
            repository: 'darling-web',
            pull_request: '#318 Fix navigation highlight',
            issues: 3,
            status: 'Completed',
            created_at: '1 hour ago'
          },
          {
            repository: 'rails-learning',
            pull_request: '#15 Add repository model',
            issues: 0,
            status: 'Processing',
            created_at: '3 hours ago'
          }
        ]
      }
    end
  end
end
