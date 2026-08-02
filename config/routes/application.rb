get 'dashboard', to: 'dashboard#index'

resources :repositories, only: %i[index show update]
resources :reviews, only: %i[index show]
resource :settings, only: :show

resource :github, only: [] do
  resource :connection, only: :create, module: :github
end
