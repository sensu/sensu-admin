require 'spec_helper'

describe Event do

  before :each do
    load "#{Rails.root}/db/seeds.rb"
    # user = FactoryGirl.create(:user)
    # user.add_role :admin
    # sign_in_user(user)
  end

  it "should return all checks through cache" do
    events = Event.all_with_cache
    events.count.should eq 2
  end

  it "should resolve an event" do
    events = Event.all
    events.count.should eq 2
    event = events[rand(events.length)]
    event.resolve.should be_true
    # TODO: would be nice if fake_sensu would delete, then switch back after one
    # GET /events
  end

  it "should return a single event" do
    event = Event.all.first
    client = event.client
    check = event.check
    single_event = Event.single("#{client}_#{check}")
    single_event.should be_a Event
  end

  it "should identify when an event's client is silenced" do
    event = Event.all.last
    client = event.client
    check = event.check
    description = "This is a test description, it is long enough"
    event.check_silenced.should_not eq nil
    # Event.silence_check(client, check, description, User.first, nil, false, nil)
    # event.check_silenced.should eq 
  end

  it "should allow manual resolution of an event" do
    event = Event.all.last
    client = event.client
    check = event.check
    user = User.last
    Event.manual_resolve(client, check, user).should be_a String
  end

  it "should allow a client to be silenced" do
    event = Event.all.last
    client = event.client
    description = "This is a test description, it is long enough"
    user = User.first
    silenced_client = Event.silence_client(client, description, user, nil, false, nil)
    silenced_client.should be_a String
    reset_fake_sensu!
  end

  it "should allow a check to be silenced" do
    event = Event.all.last
    client = event.client
    check = event.check
    description = "This is a test description, it is long enough"
    user = User.last
    silenced_check = Event.silence_check(client, check, description, user)
    silenced_check.should be_a String
    reset_fake_sensu!
  end

  it "should allow a client to be unsilenced" do
    client = Event.all.last.client
    user = User.last
    unsilenced_client = Event.unsilence_client(client, user)
    unsilenced_client.should be_a String
  end

  it "should return client attributes" do
    event = Event.all.first
    client_attributes = event.client_attributes
    client_attributes.should be_a Hash
    client_attributes.should_not be_empty
  end

  it "should return check attributes" do
    event = Event.all.first
    check_attributes = event.check_attributes
    check_attributes.should be_a Hash
    check_attributes.should_not be_empty
  end

  it "should get a client name" do
    event = Event.all.first
    event.client.should eq "i-424242"
  end

  it "should return an environment" do
    event = Event.all.first
  end

end
