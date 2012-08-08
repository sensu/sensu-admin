class Client < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = "http://localhost:4567/"


  def self.get(client)
    self.collection_name = "client"
    self.find(client)
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
