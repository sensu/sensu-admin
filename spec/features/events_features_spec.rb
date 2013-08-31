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
      page.should have_content time_ago_in_words(Time.at(1377979235))
    end

    it "should allow a check with fqdn in client name to be silenced", :js => true do
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='silence-check'][@misc='www.fqdn.com_test']").click
      page.should have_css ".modal-footer"
      within ".modal-body" do
        fill_in "text_input_www.fqdn.com_test", :with => "test comment..."
      end
      within ".modal-footer" do
        page.should have_css ".silence-submit-event"
        find(:xpath, "//a[@control='silence_submit_www.fqdn.com_test']").click
      end
      visit "/events"
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//i[@class='icon-volume-off']")
      reset_fake_sensu!
      Stash.refresh_cache
    end

    it "should allow a check with fqdn in client name to be unsilenced", :js => true do
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='silence-check'][@misc='www.fqdn.com_test']").click
      page.should have_css ".modal-footer"
      within ".modal-body" do
        fill_in "text_input_www.fqdn.com_test", :with => "test comment..."
      end
      within ".modal-footer" do
        page.should have_css ".silence-submit-event"
        find(:xpath, "//a[@control='silence_submit_www.fqdn.com_test']").click
      end
      visit "/events"
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='unsilence-submit-event'][@misc='www.fqdn.com_test']").click
      visit "/events"
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='silence-check'][@misc='www.fqdn.com_test']").click
      reset_fake_sensu!
      Stash.refresh_cache
    end

    it "should allow a client with an fqdn client-name to be silenced", :js => true do
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='silence-client'][@misc='www.fqdn.com_test']").click
      page.should have_css ".modal-footer"
      within ".modal-body" do
        fill_in "text_input_www.fqdn.com", :with => "test comment..."
      end
      within ".modal-footer" do
        page.should have_css ".silence-submit-event"
        find(:xpath, "//a[@control='silence_submit_www.fqdn.com']").click
      end
      visit "/events"
      silenced_events = page.all(:xpath, "//i[@class='icon-volume-off']").count
      silenced_events.should eq 2
      reset_fake_sensu!
      Stash.refresh_cache
    end

    it "should allow a client with an fqdn client-name to be unsilenced", :js => true do
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='silence-client'][@misc='www.fqdn.com_test']").click
      page.should have_css ".modal-footer"
      within ".modal-body" do
        fill_in "text_input_www.fqdn.com", :with => "test comment..."
      end
      within ".modal-footer" do
        page.should have_css ".silence-submit-event"
        find(:xpath, "//a[@control='silence_submit_www.fqdn.com']").click
      end
      visit "/events"
      silenced_events = page.all(:xpath, "//i[@class='icon-volume-off']").count
      silenced_events.should eq 2
      page.find(:xpath, "//button[@id='www.fqdn.com_test']").click
      page.find(:xpath, "//a[@class='unsilence-submit-event'][@misc='www.fqdn.com_test']").click
      visit "/events"
      silenced_events = page.all(:xpath, "//i[@class='icon-volume-off']").count
      silenced_events.should eq 0
      reset_fake_sensu!
      Stash.refresh_cache
    end
  end

end
