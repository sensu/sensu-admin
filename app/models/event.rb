class Event < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']

  def resolve
    post = RestClient.post "#{APP_CONFIG['api']}/event/resolve", {:client => self.client, :check => self.check }.to_json
    post.code == 201
  end

  def self.single(query)
    Event.all.select{|event| query == "#{event.client}_#{event.check}"}[0]
  end

  #
  # This is due to the API not being very Restful and ActiveResource not using .find very well
  #
  def self.manual_resolve(client, check, user)
    event = Event.single("#{client}_#{check}")
    Log.log(user, client, "resolve", nil, event)
    post = RestClient.post "#{APP_CONFIG['api']}/event/resolve", {:client => client, :check => check }.to_json
    post.code == 201
  end

  def self.silence_client(client, description, user)
    Log.log(user, client, "silence", description)
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}", {:description => description, :owner => user.email, :timestamp => Time.now.to_i }.to_json
    post.code == 201
  end

  def self.silence_check(client, check, description, user)
    event = Event.single("#{client}_#{check}")
    puts "DESCRIPTION IS: #{description}"
    Log.log(user, client, "silence", description, event)
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}/#{check}", {:description => description, :owner => user.email, :timestamp => Time.now.to_i }.to_json
    post.code == 201
  end

  def self.unsilence_client(client, user)
    Log.log(user, client, "unsilence")
    post = RestClient.delete "#{APP_CONFIG['api']}/stash/silence/#{client}"
    post.code == 204
  end

  def self.unsilence_check(client, check, user)
    event = Event.single("#{client}_#{check}")
    Log.log(user, client, "unsilence", nil, event)
    post = RestClient.delete "#{APP_CONFIG['api']}/stash/silence/#{client}/#{check}"
    post.code == 204
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

  def client_attributes
    self.attributes['client_attributes']
  end
end
