require 'spec_helper'

describe Role do

  it "has a valid factory" do
    role = FactoryGirl.create(:role)
    role.should be_valid
  end

end
