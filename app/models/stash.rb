class Stash < Resting

  def self.all
    self.all_raw
  end

  def self.all_with_cache
    Rails.cache.fetch("stashes", :expires_in => 30.seconds, :race_condition_ttl => 10) do
      self.all
    end
  end

  def self.refresh_cache
    Rails.cache.write("stashes", self.all, :expires_in => 30.seconds, :race_condition_ttl => 10)
    Rails.cache.delete("all_stashes")
  end

  def self.stashes
    api = Api.status
    sensu_version = api.sensu['version']
    Rails.cache.fetch("all_stashes", :expires_in => 30.seconds, :race_condition_ttl => 10) do
      stashes = Stash.all
      return [] if stashes.empty?
      #
      # API Blows up with a few thousand objects so lets chunk it
      #
      if Gem::Version.new(sensu_version) <= Gem::Version.new("0.9.11")
        stash_response = {}
        if stashes.count > 201
          while !stashes.empty?
            stash_post = stashes.slice!(0..200)
            stsh = post("stashes", stash_post)
            stash_response.merge!(JSON.parse(stsh.body).to_hash)
          end
        else
          stsh = post("stashes", stashes)
          stash_response = JSON.parse(stsh.body).to_hash
        end
        stash_response
      else
        stashes
      end
    end
  end

  def self.create_stash(key, attributes)
    api = Api.status
    sensu_version = api.sensu['version'] 
    if Gem::Version.new(sensu_version) <= Gem::Version.new("0.9.11") 
      post("stash/#{key}", attributes)
    else
      post("stashes", {
        :path => key,
        :content => attributes
      })
    end
  end

  def self.delete_stash(key)
    destroy(key)
  end

  def self.delete_all_stashes
    Stash.all.each do |key|
      path = key["path"]
      destroy(path)
    end
    true
  end

  def self.clear_expired_stashes
    Stash.stashes.each do |k,v|
      unless v['expire_at'].nil?
        if Time.parse(v['expire_at']) < Time.now
          puts "Clearing stash #{k} due to expiration."
          destroy(k)
        end
      end
    end and true
  end
end
