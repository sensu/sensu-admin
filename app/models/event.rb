class Event < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']

  def resolve
    post = RestClient.post "#{APP_CONFIG['api']}/event/resolve", {:client => self.client, :check => self.check }.to_json
    if post.code == 201
      true
    else
      false
    end
  end

  #
  # This is due to the API not being very Restful and ActiveResource not using .find very well
  #
  def self.manual_resolve(client, check)
    post = RestClient.post "#{APP_CONFIG['api']}/event/resolve", {:client => client, :check => check }.to_json
    if post.code == 201
      true
    else
      false
    end
  end

  def self.silence_client(client, description, username)
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}", {:description => description, :owner => username, :timestamp => Time.now }.to_json
    post.code == 201
  end

  def self.silence_check(client, check, description, username)
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}/#{check}", {:description => description, :owner => username, :timestamp => Time.now }.to_json
    post.code == 201
  end

  def client
    self.attributes['client']
  end

  def check
    self.attributes['check']
  end

  def status
    self.attributes['status']
  end

  def issued
    self.attributes['issued']
  end

  def occurrences
    self.attributes['occurrences']
  end

  def flapping
    self.attributes['flapping']
  end

  def output
    self.attributes['output']
  end

  def client_silenced
    self.attributes['client_silenced']
  end

  def check_silenced
    self.attributes['check_silenced']
  end
end
