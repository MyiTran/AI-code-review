puts '~> Creating admin users'

accounts = [
  {
    email: ENV.fetch('SUPER_ADMIN_EMAIL'),
    password: ENV.fetch('SUPER_ADMIN_PASSWORD'),
    role: :super_admin
  },
  {
    email: ENV.fetch('ADMIN_EMAIL'),
    password: ENV.fetch('ADMIN_PASSWORD'),
    role: :admin
  }
]

accounts.each do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])

  if user.new_record?
    user.password = attributes[:password]
    user.password_confirmation = attributes[:password]
    user.confirmed_at = Time.current
    user.save!
  end

  user.add_role(attributes[:role]) unless user.has_role?(attributes[:role])
end

puts '~> Created admin users'
