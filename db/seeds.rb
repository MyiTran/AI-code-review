seed_files = Rails.root.join('db/seeds/*.seeds.rb')

Dir[seed_files].sort.each do |file|
  load file
end
