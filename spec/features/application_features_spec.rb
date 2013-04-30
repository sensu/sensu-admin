require 'spec_helper'

describe "Applicaiton" do

  before :all do
    load "#{Rails.root}/db/seeds.rb" 
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
  end

  pending "should redirect to the settings page if the api does not connect" do
    visit '/settings'
    fill_in "setting_value", :with => "::55467"
    within("#api_url") do
      click_on("Update Setting")
    end
    page.body.should include "Please enter in your api server"
  end

end
