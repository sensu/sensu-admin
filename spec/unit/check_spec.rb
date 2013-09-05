require 'spec_helper'

describe Check do

  it "should submit a check" do
    check = Check.all.first
    check_name = check.name
    subscribers = check.subscribers 
    reset_fake_sensu!
  end

end
