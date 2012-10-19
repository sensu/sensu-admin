class Client < Resting

  def self.full_hash
    clienthash = {}
    Client.all.each{|c| clienthash[c.name] = { :address => c.address, :environment => c.environment}}
    clienthash
  end

  # Here so if Client is missing attributes that the view does not fail
  def method_missing(method)
    "N/A"
  end
end
