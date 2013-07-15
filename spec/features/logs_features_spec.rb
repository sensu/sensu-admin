require 'spec_helper'

describe "Logs" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/logs'
  end

  it "should show the logs page" do
    page.should have_content "Logs"
  end

end
