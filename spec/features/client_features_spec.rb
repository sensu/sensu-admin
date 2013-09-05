require 'spec_helper'

describe "Clients" do

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    Client.refresh_cache
    sign_in_user(user)
    visit '/clients'
  end

  after :each do
    reset_fake_sensu!
  end

  it "should show the clients page" do
    page.should have_content "Clients"
  end

  it "should a client name" do
    page.should have_content "i-424242"
  end

  it "should show a client address" do
    page.should have_content "127.0.0.1"
  end

  it "should show subscriptions" do
    page.should have_content "test"
  end

  it "should show a client time" do
    page.should have_content time_ago_in_words(Time.at(1377979075))
  end

end
