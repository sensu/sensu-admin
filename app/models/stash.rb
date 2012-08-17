class Stash < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  ActiveResource::Base.include_root_in_json = false
  self.site = APP_CONFIG['api']
  self.format = SensuStashFormatter.new

  def self.stashes
    stash_keys = Stash.all.collect do |stash|
      stash.attributes.keys[0]
    end
    return [] if stash_keys.empty?
    #
    # API Blows up with a few thousand objects so lets chunk it
    #
      if stash_keys.count > 201
        stash_response = {}
        while !stash_keys.empty?
          stash_post = stash_keys.slice!(0..200)
          post = RestClient.post "#{APP_CONFIG['api']}/stashes", stash_post.to_json
          stash_response.merge!(JSON.parse(post.body).to_hash)
        end
      else
        post = RestClient.post "#{APP_CONFIG['api']}/stashes", stash_keys.to_json
        stash_response = JSON.parse(post.body).to_hash
      end
      stash_response
  end

  def self.create_stash(key, attributes)
    post = RestClient.post "#{APP_CONFIG['api']}/stash/#{key}", attributes.to_json
    post.code == 201
  end

  def self.delete_stash(key)
    begin
      post = RestClient.delete "#{APP_CONFIG['api']}/stash/#{key}"
    rescue Exception => e
      puts "delete_stash took exception #{e.inspect}"
    end
    post.code == 204
  end

  def self.delete_all_stashes
    Stash.stashes.keys.each do |key|
      post = RestClient.delete "#{APP_CONFIG['api']}/stash/#{key}"
    end
    true
  end

  def self.clear_expired_stashes
    Stash.stashes.each do |k,v|
      unless v['expire_at'].nil?
        if Time.parse(v['expire_at']) < Time.now
          puts "Clearing stash #{k} due to expiration."
          Stash.delete_stash(k)
        end
      end
    end and true
  end
end
