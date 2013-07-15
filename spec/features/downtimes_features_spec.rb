require 'spec_helper'

describe "Downtimes" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/downtimes'
  end

  it "should show the downtimes page" do
    page.should have_content "Active downtimes"
  end

end
