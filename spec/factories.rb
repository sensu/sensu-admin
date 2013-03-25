require 'factory_girl'

FactoryGirl.define do

  ## Users/Roles
  factory :user do
    sequence :email do |n|
      "test_user#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'

    factory :roles do
      name "admin"
      user
    end
  end

  ## Downtimes
  factory :downtime do
    name "maintenance"
    description "shutting it down for maintenance"
    start_time { Time.now + 1.hour }
    stop_time { Time.now + 2.hours }
    user_id 1
  end
  
  factory :downtime_client do
    name "test_downtime_client"
    downtime
  end

  factory :client do
    name "test_client"
  end

  factory :downtime_in_past do
  end


  ## Setting
  factory :setting do
    name "test_configure_server"
    value true
  end

end
