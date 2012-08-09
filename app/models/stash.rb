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
      post = RestClient.post "#{APP_CONFIG['api']}/stashes", stash_keys.to_json
      JSON.parse(post.body).to_hash
  end
end
