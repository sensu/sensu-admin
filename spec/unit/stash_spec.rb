require 'spec_helper'

describe Stash do

  before :each do
    load "#{Rails.root}/db/seeds.rb"
  end

  it "should return all stashes raw" do
    stashes = Stash.all
    stashes.should be_a Array
    stashes.count.should eq 2
  end

  it "should return all stashes through cache" do
    stashes = Stash.all_with_cache
    stashes.should be_a Array
    stashes.count.should eq 2
  end

  it "should return a list of stashes when self.stashes is called" do
    stashes = Stash.stashes
    stashes.should be_a Array
    stashes.count.should eq 2
  end

  it "should create a stash" do
    stashes = Stash.stashes
    stashes.count.should eq 2
    user = User.first
    stash_key = "silence/test_stash/test"
    attributes = {
      :description => "This is a test description", 
      :owner => user.email,
      :timestamp => Time.now.to_i
    }
    stash = Stash.create_stash(stash_key, attributes)
    stash.should_not be_false
    stashes = Stash.all
    stashes.count.should eq 3
    reset_fake_sensu!
  end

  it "should delete a stash" do
    stashes = Stash.all
    stashes.count.should eq 2
    stash = stashes.last
    key = stash["path"]
    Stash.delete_stash(key).should_not be_false
    stashes = Stash.all
    stashes.count.should eq 1
    reset_fake_sensu!
  end

  it "should delete all stashes" do
    stashes = Stash.all
    stashes.count.should eq 2
    Stash.delete_all_stashes
    stashes = Stash.all
    stashes.count.should eq 0
    reset_fake_sensu!
  end

  pending "should paginate stashes (see Stash.stashes)" do
  end

end
