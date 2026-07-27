get "dashboard", to: "dashboard#index"

resources :repositories, only: %i[index show]
resources :reviews, only: %i[index show]
resource :settings, only: :show