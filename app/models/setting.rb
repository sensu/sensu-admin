class Setting < ActiveRecord::Base
  attr_accessible :name, :value
  validates_uniqueness_of :name

  def self.api_server
    Rails.cache.fetch("api_server", :expires_in => 15.minutes, :race_condition_ttl => 10) do
      find_by_name("api_server").value
    end
  end

  def self.use_environments?
    Rails.cache.fetch("use_environments", :expires_in => 15.minutes, :race_condition_ttl => 10) do
      find_by_name("use_environments").value == "true"
    end
  end

  def self.flush_cache
    REQUIRED_SETTINGS.each do |setting|
      Rails.cache.delete(setting)
    end
  end
end
