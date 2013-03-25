require 'spec_helper'

describe "Applicaiton" do

  before :all do
    load "#{Rails.root}/db/seeds.rb" 
  end

  before :each do
    user = FactoryGirl.create(:user)
    sign_in_user(user)
  end

  it "should redirect to the settings page if the api does not connect" do
    visit events_path
    page.body.should include "Please enter in your api server"
  end

end
