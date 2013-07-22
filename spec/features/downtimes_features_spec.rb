require 'spec_helper'

describe "Downtimes" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
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

  it "should allow creation of a new downtime" do
    page.should have_link "Create Downtime"
    click_link "Create Downtime"
    time_now = Time.now.utc
    fill_in "downtime[name]", :with => "Test Downtime"
    fill_in "downtime[description]", :with  => "This is a test description"
    fill_in "downtime_start_date", :with => (time_now + 12.hours).strftime("%d/%m/%Y")
    fill_in "downtime_end_date", :with => (time_now + 13.hours).strftime("%d/%m/%Y")
    t1 = Time.at(time_now.to_i/(15*60)*(15*60)) + 12.hours
    t2 = Time.at(time_now.to_i/(15*60)*(15*60)) + 13.hours
    fill_in "downtime[begin_time]", :with => t1.strftime("%-l:%M%P")
    fill_in "downtime[end_time]", :with => t2.strftime("%-l:%M%P")
    check "downtime[client_ids][]"
    click_button "Create Downtime"
    page.should have_content "Test Downtime"
    page.should have_content "This is a test description"
  end

end
