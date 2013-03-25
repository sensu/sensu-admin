require 'spec_helper'

describe "Events" do

  before :all do
    load "#{Rails.root}/db/seeds.rb" 
  end

  before :each do
    user = FactoryGirl.create(:user)
    sign_in_user(user)
  end

  it "should show the events page" do
  end

end
