require 'spec_helper'

describe "Stats" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/stats'
  end

  it "should show the stats page" do
    page.should have_content "Stats"
  end

  it "should show clients by subscriptions" do
    within("#clients-by-subscriptions") { find("td", :text => "test") }
  end

  it "should show clients by environment" do
    within("#clients-by-environment") { find("td", :text => "None") }
  end

  it "should show miscellaneous client stats" do
    within("#clients-misc tbody") do
      find("td", :text => "Total Clients")
      page.should have_content Client.all.count
    end
  end

  it "should show events by check" do
    within("#events-by-check") do
      page.should have_content "tokens"
    end
  end

  it "should show events by environment" do
    within("#events-by-environment") do
      page.should have_content "2"
    end
  end

  it "should show events per client" do
    within("#events-per-client") do
      page.should have_content "i-424242"
    end
  end

  it "should show miscellaneous event stats" do
    within("#events-misc") do
      page.should have_content "Total Events"
    end
  end

end
