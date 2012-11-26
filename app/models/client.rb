class Client < Resting
  def self.all_with_cache
    clients = Rails.cache.read("clients")
    if clients.nil?
      clients = Client.all
      Rails.cache.write("clients", clients, :expires_in => 45.seconds, :race_condition_ttl => 10)
      clients.each do |client|
        client_data = JSON.parse(client.to_json) # We only want attributes
        Rails.cache.write(client.name, client_data, :expires_in => 5.minutes, :race_condition_ttl => 10)
      end
    end
    clients
  end

  def self.refresh_cache
    Rails.cache.write("clients", Client.all, :expires_in => 30.seconds, :race_condition_ttl => 10)
  end

  def self.full_hash
    clienthash = {}
    Client.all_with_cache.each{|c| clienthash[c.name] = { :address => c.address, :environment => c.environment}}
    clienthash
  end

  # Here so if Client is missing attributes that the view does not fail
  def method_missing(method, *args, &block)
    "None"
  end
end
