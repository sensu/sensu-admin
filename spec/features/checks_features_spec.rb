require 'spec_helper'

describe "Checks" do

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/checks'
  end

  after :each do
    reset_fake_sensu!
  end

  it "should show the checks page" do
    page.should have_content "Checks"
  end

  it "should show a list of checks" do
    page.should have_content "test"
  end

end

