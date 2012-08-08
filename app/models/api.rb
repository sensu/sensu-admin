class Api < ActiveResource::Base
  #include ActiveResource::Extend::WithoutExtension
  #self.site = "http://localhost:4567/"
  #self.format = SensuJSONFormatter.new
  #self.collection_name = "info"
  def self.status
    JSON.parse(open("http://localhost:4567/info").read)
  end

  def self.version
    self.status['sensu']['version']
  end

  def self.redis_health
    self.status['health']['redis']
  end

  def self.rabbitmq_health
    self.status['health']['rabbitmq']
  end
end
