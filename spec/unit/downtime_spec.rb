require 'spec_helper'

describe Downtime do

  before :each do
    load "#{Rails.root}/db/seeds.rb"
    @downtime = Downtime.new(
      :name => 'test_downtime', 
      :user_id => User.last.id, 
      :description => "This is a test description, for testing",
      :start_time => Time.now + 2.hours,
      :stop_time => Time.now + 3.hours
    )

  end

  it "should create downtimes" do
    @downtime.should be_valid
  end

  it "should not fail due to ruby issue #8173" do
    downtime = Downtime.create!(
      :name => "test_downtime_2",
      :user_id => User.last.id,
      :description => "This downtime should not fail due to issue with TimeWithZone",
      :start_time => Timecop.freeze(Time.zone.now),
      :stop_time => Timecop.freeze(Time.zone.now + 2.hours)
    )
    lambda { Time.at(downtime.stop_time) }.should raise_error
    lambda { Time.at(downtime.stop_time.to_i) }.should_not raise_error
  end

end
