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

    it "should show multiple events", :js => true do
      page.should have_content "test"
    end

    it "should show the client for an event", :js => true do
      page.should have_content "i-424242"
    end

    it "should show the check for an event", :js => true do
      page.should have_content "test"
    end

    it "should show the output for an event", :js => true do
      page.body.should have_content "Crit i-424242"
    end

    it "should show time since issued for an event", :js => true do
      page.should have_content time_ago_in_words(Time.at(1377890282))
    end

    it "should allow a check to be silenced", :js => true do
      page.find("#dropdown_toggle_0").click
      page.find("#silence_check_0").click
      reset_fake_sensu!
    end

    it "should allow a check to be unsilenced", :js => true do
      # page.find("#dropdown_toggle_0").click
      # page.find("#unsilence_check_0").click
      # visit '/events'
      # page.find("#silence_check_0").click
      # reset_fake_sensu!
    end
  end

end
