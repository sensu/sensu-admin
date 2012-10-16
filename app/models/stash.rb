class Stash < Resting

  def self.all
    self.all_raw
  end

  def self.stashes
    stash_keys = Stash.all
    return [] if stash_keys.empty?
    #
    # API Blows up with a few thousand objects so lets chunk it
    #
      if stash_keys.count > 201
        stash_response = {}
        while !stash_keys.empty?
          stash_post = stash_keys.slice!(0..200)
          stsh = post("stashes", stash_post)
          stash_response.merge!(JSON.parse(stsh.body).to_hash)
        end
      else
        stsh = post("stashes", stash_keys)
        stash_response = JSON.parse(stsh.body).to_hash
      end
      stash_response
  end

  def self.create_stash(key, attributes)
    post("stash/#{key}", attributes)
  end

  def self.delete_stash(key)
    destroy(key)
  end

  def self.delete_all_stashes
    Stash.all.each do |key|
      destroy(key)
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
