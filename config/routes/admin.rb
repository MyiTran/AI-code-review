devise_scope :user do
  get 'admin/login', to: 'admin/sessions#new', as: :admin_login
  post 'admin/login', to: 'admin/sessions#create', as: :admin_session
  delete 'admin/logout', to: 'admin/sessions#destroy', as: :admin_logout
end

namespace :admin do
  root 'users#index'

  resources :users, only: %i[index show update] do
    resources :repositories, only: :show do
      resources :pull_requests, only: :show do
        resources :reviews, only: :show
      end
    end
  end

  resources :admins
end
