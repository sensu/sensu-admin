require 'spec_helper'

describe Api do

  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  it "should return a status" do
    status = Api.status
    status.should be_a Api
    status.should_not be_nil
    status.should_not be_false
  end

  it "should return a version" do
    version = Api.version
    version.should_not be_false
    version.should_not be_nil
  end

  it "should return redis health" do
    redis_health = Api.redis_health
    redis_health.should_not be_false
    redis_health.should_not be_nil
  end

  it "should return rabbit health" do
    rabbit_health = Api.rabbitmq_health
    rabbit_health.should_not be_nil
  end

end
