## Requirements

Make sure the following dependencies are installed:

* Ruby 3.4.7
* Ruby on Rails 8.1.3.1
* PostgreSQL
* Redis
* Node.js
* Bundler

## Project Setup

Clone the repository:

```bash
git clone https://github.com/MyiTran/AI-code-review.git
cd AI-code-review
```

Install Ruby dependencies:

```bash
bundle install
```

Install frontend dependencies:

```bash
npm install
```

Prepare the database:

```bash
bin/rails db:prepare
```

## Environment Variables

Create a local environment file:

```bash
cp .env.example .env
```

Configure the following variables in `.env`:

```dotenv
# Application
APP_HOST=localhost:3000
APP_PROTOCOL=http

# Redis and Sidekiq
REDIS_URL=redis://127.0.0.1:6379/1

# GitHub App
GITHUB_APP_ID=
GITHUB_APP_SLUG=
GITHUB_APP_PRIVATE_KEY=
GITHUB_WEBHOOK_SECRET=

# GitHub OAuth
GITHUB_OAUTH_CLIENT_ID=
GITHUB_OAUTH_CLIENT_SECRET=

# Google Gemini
GEMINI_API_KEY=

# Active Record Encryption
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=

# Free plan limits
FREE_REPOSITORIES_LIMIT=3
FREE_PULL_REQUESTS_LIMIT=30
FREE_REVIEWS_LIMIT=60

# Pro plan limits
PRO_REPOSITORIES_LIMIT=50
PRO_PULL_REQUESTS_LIMIT=500
PRO_REVIEWS_LIMIT=1000
```

Generate the Active Record encryption keys if necessary:

```bash
bin/rails db:encryption:init
```

Copy the generated values into `.env`.

Do not commit `.env`, the GitHub private key, webhook secret, OAuth secret, Gemini API key, or encryption keys to Git.

### GitHub App Configuration

Configure the following URLs in the GitHub App settings.

For local development:

```text
Homepage URL:
http://localhost:3000

Setup URL:
http://localhost:3000/callback/github

Webhook URL:
https://<your-ngrok-domain>/webhooks/github
```

Start a public tunnel for the local webhook endpoint:

```bash
ngrok http 3000
```

Copy the generated HTTPS URL and update the GitHub App Webhook URL:

```text
https://<your-ngrok-domain>/webhooks/github
```

The webhook secret configured on GitHub must match:

```dotenv
GITHUB_WEBHOOK_SECRET=
```

## Database Design

The Entity Relationship Diagram describes the relationships between users, GitHub installations, repositories, pull requests, reviews, AI models, subscriptions, roles, and webhook deliveries.

[View the Entity Relationship Diagram](ERD_URL)

Replace `<ERD_URL>` with the public link to the ERD, for example a GitHub image, dbdiagram.io document, Lucidchart diagram, or project documentation page.

## Running the Application

Make sure PostgreSQL and Redis are running.

On macOS with Homebrew:

```bash
brew services start postgresql
brew services start redis
```

If the project contains a `Procfile.dev`, start all development processes with:

```bash
bin/dev
```

Otherwise, run the services in separate terminals.

Start Rails:

```bash
bin/rails server
```

Start Sidekiq:

```bash
bundle exec sidekiq
```

Start the Vite development server:

```bash
bin/vite dev
```

Open the application:

```text
http://localhost:3000
```

For local GitHub webhook testing, keep ngrok running:

```bash
ngrok http 3000
```

## Running Tests

Create and prepare the test database:

```bash
RAILS_ENV=test \
DATABASE_URL=postgresql://localhost/ai_code_review_test \
bin/rails db:test:prepare
```

Run the complete test suite:

```bash
RAILS_ENV=test \
DATABASE_URL=postgresql://localhost/ai_code_review_test \
bin/rspec
```

Run a specific spec file:

```bash
RAILS_ENV=test \
DATABASE_URL=postgresql://localhost/ai_code_review_test \
bin/rspec spec/services/github/fetch_installation_service_spec.rb
```

The project uses:

* RSpec for automated testing.
* FactoryBot for generating test data.
* VCR for recording and replaying external HTTP requests.
* SimpleCov for measuring test coverage.

The SimpleCov coverage report is generated at:

```text
coverage/index.html
```

## Test Results & Coverage

Run the complete test suite:

```bash
RAILS_ENV=test \
DATABASE_URL=postgresql://localhost/ai_code_review_test \
bin/rspec
```

Total Examples: 99 passing tests (0 failures)

Code Coverage: 87.46% (328 / 375 relevant lines covered)
<img width="1460" height="284" alt="image" src="https://github.com/user-attachments/assets/65a88e3d-8dcc-4d44-be9e-d65c8d7816e6" />


## Background Processing

GitHub webhook deliveries and AI reviews are processed asynchronously.

The processing flow is:

```text
GitHub Webhook
→ Rails webhook endpoint
→ PostgreSQL stores the delivery
→ Redis queues the job
→ Sidekiq processes the Pull Request
→ Gemini generates the AI review
→ GitHub App posts the review comment
```

Sidekiq must be running for Pull Request synchronization and AI Review generation to work.

## Useful Commands

Check the webhook route:

```bash
bin/rails routes | grep webhook
```

Open the Rails console:

```bash
bin/rails console
```

Check the current database:

```bash
bin/rails runner '
puts "Environment: #{Rails.env}"
puts "Database: #{ActiveRecord::Base.connection.select_value("SELECT current_database()")}"
'
```

Run code quality checks:

```bash
bin/rubocop
```
