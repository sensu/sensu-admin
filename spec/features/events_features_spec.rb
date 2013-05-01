require 'spec_helper'

describe "Events" do

  context "When API fully functional" do
    before :all do
      load "#{Rails.root}/db/seeds.rb" 
    end

    before :each do
      user = FactoryGirl.create(:user)
      user.add_role :admin
      sign_in_user(user)
      visit '/events'
    end

    it "should show the events page" do
      page.should have_content "Events"
    end

    it "should show multiple events" do
      page.should have_content "standalone"
      page.should have_content "tokens"
    end

    it "should show the client for an event" do
      page.should have_content "i-424242"
    end

    it "should show the check for an event" do
      page.should have_content "standalone"
    end

    it "should show the output for an event", :js => true do
      page.body.should have_content "i-424242 true"
    end

    it "should show time since issued for an event", :js => true do
      page.should have_content time_ago_in_words(Time.at(1364343741))
    end

  end

end
