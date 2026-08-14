namespace :callback do
  # GitHub redirects here via GET after installation, handled by the create action
  get 'github', to: 'github#create'
end
