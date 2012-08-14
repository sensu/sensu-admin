class Check < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']
  self.collection_name = 'checks'

  def name
    self.attributes['name']
  end

  def self.submit_check(check, subscribers)
    post = RestClient.post "#{APP_CONFIG['api']}/check/request", {:check => check, :subscribers => subscribers }.to_json
    post.code == 201
  end
end
