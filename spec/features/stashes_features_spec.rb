require 'spec_helper'

describe "Stashes" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    Stash.refresh_cache
    sign_in_user(user)
    visit '/stashes'
  end

  after :each do
    reset_fake_sensu!
  end

  it "should show the stashes page" do
    page.should have_content "Stashes"
  end

  it "should show the correct stash count" do
    page.should have_content "Stashes (#{Stash.all.count})"
  end

  it "should show stashes and correct data" do
    page.should have_content "tester"
    page.should have_content "Never"
    page.should have_content "43 years ago"
  end

  it "should have a delete link" do
    page.should have_button "Delete"
  end

  pending "should allow deletion of a stash", :js => true do
    page.should have_selector("#silence-i-424242-tokens", :text => "Delete")
    find("#silence-i-424242-tokens", :text => "Delete").click
    page.should_not have_selector("#silence-i-424242-tokens", :text => "Delete")
  end

end
