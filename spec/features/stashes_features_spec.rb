require 'spec_helper'

describe "Stashes" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/stashes'
  end

  it "should show the stashes page" do
    page.should have_content "Stashes"
  end

  it "should show the correct stash count" do
    page.should have_content "Stashes (#{Stash.all.count})"
  end

  it "should show stashes and correct data" do
    page.should have_content "silence/i-424242/tokens"
    page.should have_content "Never"
    page.should have_content time_ago_in_words(Time.at(1364332102))
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
