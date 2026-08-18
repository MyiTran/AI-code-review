puts '~> Creating admins'
FactoryBot.create_list(:user, 5, :admin)
puts '~> Created admins'
