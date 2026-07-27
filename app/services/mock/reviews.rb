module Mock
  class Reviews
    DATA = [
      {
        id: 101,
        repository_id: 1,
        repository_name: 'ai-code-review-github',
        repository_full_name: 'MyiTran/ai-code-review-github',
        pull_request_number: 42,
        title: 'Add GitHub webhook handler',
        description: 'Add a webhook endpoint to receive pull request events from GitHub.',
        source_branch: 'feature/github-webhook',
        target_branch: 'main',
        author: 'Hazel Tran',
        author_initials: 'HT',
        commit_sha: 'a3f27bc',
        model: 'Gemini 2.5 Flash',
        status: 'Completed',
        conclusion: 'Changes requested',
        issues_found: 6,
        critical_count: 1,
        warning_count: 3,
        suggestion_count: 2,
        files_changed: 5,
        additions: 184,
        deletions: 32,
        reviewed_at: '10 minutes ago',
        duration: '18 seconds',
        github_url: 'https://github.com/MyiTran/ai-code-review-github/pull/42',

        summary: 'The webhook implementation is generally well structured, but signature verification must be added before the endpoint can be considered secure. Error handling and payload validation should also be improved.',

        findings: [
          {
            id: 1,
            severity: 'Critical',
            category: 'Security',
            title: 'Webhook signature is not verified',
            file_path: 'app/controllers/api/v1/webhooks_controller.rb',
            line_number: 12,
            description: 'The endpoint accepts GitHub webhook payloads without verifying the X-Hub-Signature-256 header.',
            suggestion: 'Generate an HMAC digest using the GitHub webhook secret and compare it securely with the request signature.',
            code: 'payload = JSON.parse(request.body.read)'
          },
          {
            id: 2,
            severity: 'Warning',
            category: 'Reliability',
            title: 'JSON parsing errors are not handled',
            file_path: 'app/controllers/api/v1/webhooks_controller.rb',
            line_number: 15,
            description: 'Invalid JSON will raise JSON::ParserError and return an unhandled server error.',
            suggestion: 'Rescue JSON::ParserError and return a 400 Bad Request response.',
            code: 'event = JSON.parse(request.body.read)'
          },
          {
            id: 3,
            severity: 'Warning',
            category: 'Maintainability',
            title: 'Controller contains event-processing logic',
            file_path: 'app/controllers/api/v1/webhooks_controller.rb',
            line_number: 24,
            description: 'The controller performs payload parsing and event processing directly.',
            suggestion: 'Move webhook processing into a dedicated service object.',
            code: 'process_pull_request(payload)'
          },
          {
            id: 4,
            severity: 'Warning',
            category: 'Testing',
            title: 'Missing webhook request tests',
            file_path: 'spec/requests/api/v1/webhooks_spec.rb',
            line_number: 1,
            description: 'No tests cover valid signatures, invalid signatures or malformed payloads.',
            suggestion: 'Add request specs for successful and rejected webhook requests.',
            code: nil
          },
          {
            id: 5,
            severity: 'Suggestion',
            category: 'Performance',
            title: 'Webhook processing should run asynchronously',
            file_path: 'app/controllers/api/v1/webhooks_controller.rb',
            line_number: 30,
            description: 'Processing the webhook inside the request may cause GitHub to wait for a response.',
            suggestion: 'Enqueue an Active Job and immediately return a 202 Accepted response.',
            code: 'ReviewPullRequestService.call(payload)'
          },
          {
            id: 6,
            severity: 'Suggestion',
            category: 'Style',
            title: 'Use a constant for supported events',
            file_path: 'app/controllers/api/v1/webhooks_controller.rb',
            line_number: 8,
            description: 'Supported event names are hardcoded inside the controller.',
            suggestion: 'Extract supported events into a frozen constant.',
            code: 'return unless event == "pull_request"'
          }
        ],

        changed_files: [
          {
            path: 'app/controllers/api/v1/webhooks_controller.rb',
            additions: 58,
            deletions: 8,
            findings_count: 4
          },
          {
            path: 'app/services/github/webhook_service.rb',
            additions: 71,
            deletions: 4,
            findings_count: 1
          },
          {
            path: 'config/routes.rb',
            additions: 4,
            deletions: 0,
            findings_count: 0
          },
          {
            path: 'spec/requests/api/v1/webhooks_spec.rb',
            additions: 42,
            deletions: 16,
            findings_count: 1
          },
          {
            path: 'spec/services/github/webhook_service_spec.rb',
            additions: 9,
            deletions: 4,
            findings_count: 0
          }
        ]
      },

      {
        id: 102,
        repository_id: 1,
        repository_name: 'ai-code-review-github',
        repository_full_name: 'MyiTran/ai-code-review-github',
        pull_request_number: 39,
        title: 'Create repository dashboard',
        description: 'Add repository list and repository detail pages.',
        source_branch: 'feature/repository-dashboard',
        target_branch: 'main',
        author: 'Hazel Tran',
        author_initials: 'HT',
        commit_sha: 'b814ef1',
        model: 'Gemini 2.5 Flash',
        status: 'Completed',
        conclusion: 'Approved with suggestions',
        issues_found: 3,
        critical_count: 0,
        warning_count: 1,
        suggestion_count: 2,
        files_changed: 8,
        additions: 426,
        deletions: 21,
        reviewed_at: '2 hours ago',
        duration: '24 seconds',
        github_url: 'https://github.com/MyiTran/ai-code-review-github/pull/39',

        summary: 'The dashboard implementation is clear and visually consistent. A few improvements are recommended for view maintainability, accessibility and duplication reduction.',

        findings: [
          {
            id: 1,
            severity: 'Warning',
            category: 'Maintainability',
            title: 'View file is too large',
            file_path: 'app/views/web/repositories/show.html.slim',
            line_number: 1,
            description: 'The repository detail view contains several independent UI sections in one file.',
            suggestion: 'Extract the statistics, review history and settings sections into partials.',
            code: nil
          },
          {
            id: 2,
            severity: 'Suggestion',
            category: 'Accessibility',
            title: 'Button requires a more descriptive label',
            file_path: 'app/views/web/repositories/index.html.slim',
            line_number: 138,
            description: 'The icon-only button may not clearly describe its destination to assistive technologies.',
            suggestion: 'Add an aria-label that includes the repository name.',
            code: 'i.bi.bi-chevron-right'
          },
          {
            id: 3,
            severity: 'Suggestion',
            category: 'Maintainability',
            title: 'Repository status styling is duplicated',
            file_path: 'app/views/web/repositories/index.html.slim',
            line_number: 142,
            description: 'Connection badge logic may be reused across multiple views.',
            suggestion: 'Move connection badge rendering into a helper or partial.',
            code: nil
          }
        ],

        changed_files: [
          {
            path: 'app/views/web/repositories/index.html.slim',
            additions: 171,
            deletions: 5,
            findings_count: 2
          },
          {
            path: 'app/views/web/repositories/show.html.slim',
            additions: 206,
            deletions: 2,
            findings_count: 1
          },
          {
            path: 'app/controllers/web/repositories_controller.rb',
            additions: 52,
            deletions: 4,
            findings_count: 0
          }
        ]
      },

      {
        id: 201,
        repository_id: 2,
        repository_name: 'darling-web',
        repository_full_name: 'MyiTran/darling-web',
        pull_request_number: 318,
        title: 'Fix navigation highlight',
        description: 'Correct active navigation state while scrolling between sections.',
        source_branch: 'fix/navigation-highlight',
        target_branch: 'develop',
        author: 'Developer One',
        author_initials: 'DO',
        commit_sha: 'e82a19d',
        model: 'Claude Sonnet',
        status: 'Completed',
        conclusion: 'Changes requested',
        issues_found: 3,
        critical_count: 0,
        warning_count: 2,
        suggestion_count: 1,
        files_changed: 4,
        additions: 73,
        deletions: 28,
        reviewed_at: 'Yesterday',
        duration: '14 seconds',
        github_url: '#',

        summary: 'The navigation fix handles the primary case, but event listener cleanup and active-item calculation should be improved.',

        findings: [
          {
            id: 1,
            severity: 'Warning',
            category: 'Performance',
            title: 'Scroll listener is not throttled',
            file_path: 'src/components/SecondaryNavigation.tsx',
            line_number: 41,
            description: 'The scroll handler may execute many times per second.',
            suggestion: 'Use requestAnimationFrame, throttling or IntersectionObserver.',
            code: 'window.addEventListener("scroll", handleScroll)'
          },
          {
            id: 2,
            severity: 'Warning',
            category: 'Reliability',
            title: 'Event listener cleanup is missing',
            file_path: 'src/components/SecondaryNavigation.tsx',
            line_number: 42,
            description: 'The listener remains active after the component is unmounted.',
            suggestion: 'Return a cleanup callback from useEffect.',
            code: nil
          },
          {
            id: 3,
            severity: 'Suggestion',
            category: 'Testing',
            title: 'Add coverage for overflow navigation',
            file_path: 'tests/navigation.spec.ts',
            line_number: 18,
            description: 'The current tests do not cover horizontal navigation overflow.',
            suggestion: 'Add a test that verifies the active item scrolls into view.',
            code: nil
          }
        ],

        changed_files: [
          {
            path: 'src/components/SecondaryNavigation.tsx',
            additions: 42,
            deletions: 18,
            findings_count: 2
          },
          {
            path: 'tests/navigation.spec.ts',
            additions: 23,
            deletions: 5,
            findings_count: 1
          }
        ]
      },

      {
        id: 301,
        repository_id: 3,
        repository_name: 'rails-learning',
        repository_full_name: 'MyiTran/rails-learning',
        pull_request_number: 15,
        title: 'Add repository model',
        description: 'Create repository model and associations.',
        source_branch: 'feature/repository-model',
        target_branch: 'main',
        author: 'Hazel Tran',
        author_initials: 'HT',
        commit_sha: 'd213fc8',
        model: 'GPT-4.1 Mini',
        status: 'Completed',
        conclusion: 'Approved',
        issues_found: 0,
        critical_count: 0,
        warning_count: 0,
        suggestion_count: 0,
        files_changed: 3,
        additions: 82,
        deletions: 0,
        reviewed_at: '3 days ago',
        duration: '9 seconds',
        github_url: '#',

        summary: 'No significant issues were detected. The model, migration and validation tests are consistent with the current requirements.',

        findings: [],

        changed_files: [
          {
            path: 'app/models/repository.rb',
            additions: 21,
            deletions: 0,
            findings_count: 0
          },
          {
            path: 'db/migrate/20260718000000_create_repositories.rb',
            additions: 34,
            deletions: 0,
            findings_count: 0
          },
          {
            path: 'spec/models/repository_spec.rb',
            additions: 27,
            deletions: 0,
            findings_count: 0
          }
        ]
      },

      {
        id: 501,
        repository_id: 1,
        repository_name: 'ai-code-review-github',
        repository_full_name: 'MyiTran/ai-code-review-github',
        pull_request_number: 44,
        title: 'Add background review job',
        description: 'Process AI reviews with Active Job and Sidekiq.',
        source_branch: 'feature/review-job',
        target_branch: 'main',
        author: 'Hazel Tran',
        author_initials: 'HT',
        commit_sha: 'f28c17a',
        model: 'Gemini 2.5 Flash',
        status: 'Processing',
        conclusion: 'In progress',
        issues_found: 0,
        critical_count: 0,
        warning_count: 0,
        suggestion_count: 0,
        files_changed: 4,
        additions: 118,
        deletions: 12,
        reviewed_at: 'Just now',
        duration: 'Running',
        github_url: '#',

        summary: 'The AI review is currently being processed.',

        findings: [],
        changed_files: []
      }
    ].freeze

    def self.all
      DATA
    end

    def self.find(id)
      DATA.find do |review|
        review[:id].to_s == id.to_s
      end
    end
  end
end
