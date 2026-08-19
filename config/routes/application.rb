get 'dashboard', to: 'dashboard#index'

resources :repositories, only: %i[index show update]
resources :reviews, only: %i[index show] do
  resource :retry, only: :create, controller: 'review_retries'
end
resource :settings, only: :show
resources :pull_requests, only: :show

resource :github, only: [] do
  resource :connection, only: :create, module: :github
end
