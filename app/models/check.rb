class Check < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']
  self.collection_name = 'checks'

  def name
    self.attributes['name']
  end
end
