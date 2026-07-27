devise_for(
  :users,
  skip: [:registrations],
  controllers: {
    sessions: "authentication/sessions",
    passwords: "authentication/passwords",
    confirmations: "authentication/confirmations",
    registrations: "authentication/registrations",
    omniauth_callbacks: "authentication/omniauth_callbacks"
  }
)