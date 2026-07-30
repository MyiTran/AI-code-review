get 'dashboard', to: 'dashboard#index'

resources :repositories, only: %i[index show] do
  collection do
    get :connect
  end
end
resources :reviews, only: %i[index show]
resource :settings, only: :show
