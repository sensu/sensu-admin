require 'spec_helper'

describe Client do
  
  it "should return all clients through cache" do
    Client.refresh_cache
    clients = Client.all_with_cache
    clients.count.should eq 2
  end

  it "should return all clients as a hash" do
    Client.refresh_cache
    clients_hash = Client.full_hash
    clients_hash.should be_a Hash
    clients_hash.should_not be_empty
    clients_hash.count.should eq 2
  end

end
