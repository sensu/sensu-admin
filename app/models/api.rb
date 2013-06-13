class Api < Resting

  def self.status
    get("info")
  end

  def self.version
    self.status.sensu['version']
  end

  def self.redis_health
    self.status.redis['connected']
  end

  def self.rabbitmq_health
    self.status.rabbitmq['connected']
  end
end
