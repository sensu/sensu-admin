require 'spec_helper'

describe "Aggregates" do

  before :each do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    sign_in_user(user)
    visit '/aggregates'
  end

  it "should show the aggregates page" do
    page.should have_content "Aggregates"
  end

end
