# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.all.count == 0
  u = User.create!({:email => "admin@example.com", :password => "secret", :password_confirmation => "secret" })
  u.add_role :admin
  u.save!
end
