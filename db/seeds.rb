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

unless Setting.find_by_name("api_server")
  # Sensu API supports http basic auth, so if your using that -- just do http://user:pass@localhost:4567, no trailing /
  Setting.create(:name => "api_server", :value => "http://localhost:4567")
end

unless Setting.find_by_name("use_environments")
  Setting.create(:name => "use_environments", :value => "false")
end
