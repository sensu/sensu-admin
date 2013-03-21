require 'spec_helper'

describe "Events" do
  before :each do
    @user = FactoryGirl.create(:user)
    log_in_user(@user)
  end

  # /events
  it "should return 200 success" do
    get events_path
    response.code.should eq 200
  end
end
