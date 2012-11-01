class Client < Resting

  def self.all_with_cache
    Rails.cache.fetch("clients", :expires_in => 30.seconds, :race_condition_ttl => 10) do
      all
    end
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
  def method_missing(method)
    "N/A"
  end
end
