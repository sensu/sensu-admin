require 'spec_helper'

describe DowntimeCheck do
  
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  it "has a valid factory" do
    downtime_check = FactoryGirl.create(:downtime_check)
    downtime_check.should be_valid
  end

end
