Rails.application.routes.draw do
  root 'home#index'

  draw(:system)
  draw(:user)
  draw(:application)
  draw(:webhook)
  draw(:github)
  draw(:admin)
end
