# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'ROLES'
['admin', 'provider'].each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.create_with(:password => ENV['ADMIN_PASSWORD'].dup).find_or_create_by(:name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup)
puts 'user: ' << user.name
user.add_role :admin
user.skip_confirmation!
user.save!