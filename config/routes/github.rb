namespace :github do
  resources :installations, only: [] do
    collection do
      get :callback
    end
  end
end
