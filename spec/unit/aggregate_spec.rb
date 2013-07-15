require 'spec_helper'

describe Aggregate do

  it "should return a hash of all aggregates" do
    aggregates = Aggregate.all
    aggregates.should be_false
  end

end
