require 'spec_helper'

describe "Downtimes" do

  before :all do
    load "#{Rails.root}/db/seeds.rb"
    @downtime = Downtime.create!(
      :name => 'test_downtime_integration',
      :user_id => User.last.id,
      :description => "This tests to make sure page doesn't blow up when TimeWithZone is used w/o .to_i",
      :start_time => Time.now + 1.hours,
      :stop_time => Time.now + 2.hours
    )
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/downtimes'
  end

  it "should show the downtimes page" do
    page.should have_content "Active downtimes"
  end

  it "should show a downtime" do
    page.should have_content @downtime.start_time
    page.should have_content @downtime.stop_time
    page.should have_content @downtime.description
  end

end
