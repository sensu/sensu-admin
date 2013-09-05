require 'spec_helper'

describe Aggregate do

  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  it "should return a hash of all aggregates" do
    aggregates = Aggregate.all
    aggregates.should be_false
  end

end
