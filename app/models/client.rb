class Client < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']
  self.collection_name = 'clients'


  #
  # You cant use a .get here or GET /client/<id> because then you have
  # to set .collection_name to 'client' and it will blow up subsequent
  # queries when Client.all is called
  #
  def self.single(query)
    Client.all.select{|client| client.name == query}[0]
  end

  def self.full_hash
    clienthash = {}
    Client.all.each{|c| clienthash[c.name] = { :address => c.address, :environment => c.environment}}
    clienthash
  end

  def subscriptions
    self.attributes['subscriptions']
  end

  def name
    self.attributes['name']
  end

  def primary_role
    self.attributes['primary_role']
  end

  def timestamp
    self.attributes['timestamp']
  end

  def environment
    self.attributes['environment']
  end
end
