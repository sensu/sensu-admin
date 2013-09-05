require 'spec_helper'

describe Check do

  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  it "should submit a check" do
    check = Check.all.first
    check_name = check.name
    subscribers = check.subscribers 
    reset_fake_sensu!
  end

end
