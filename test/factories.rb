require 'factory_girl'

FactoryGirl.define do

  ## Users/Roles
  factory :user do
    sequence :email do |n|
      "test_user#{n}@example.com"
    end
    password '123'
    password_confirmation '123'
    role
  end

  factory :role do
    name "admin"
  end

  ## Downtimes
  factory :downtime do
    name "maintenance"
    description "shutting it down for maintenance"
    start_time { Time.now + 1.hour }
    stop_time { Time.now + 2.hours }
    user_id 1
    association :downtime_client
  end

  factory :downtime_in_past do
  end

  factory :downtime_client do
    name "test_downtime_client"
  end

  factory :client do
    name "test_client"
  end

end
