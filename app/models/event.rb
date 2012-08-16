class Event < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = APP_CONFIG['api']

  def resolve
    post = RestClient.delete "#{APP_CONFIG['api']}/event/#{self.client}/#{self.check}"
    post.code == 202
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
    post = RestClient.delete "#{APP_CONFIG['api']}/event/#{client}/#{check}"
    post.code == 202
  end

  def self.silence_client(client, description, user, expire_at = nil, log = true, downtime_id = nil)
    Log.log(user, client, "silence", description) if log
    post_data = {:description => description, :owner => user.email, :timestamp => Time.now.to_i }
    post_data[:expire_at] = expire_at unless expire_at.nil?
    post_data[:downtime_id] = downtime_id unless downtime_id.nil?
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}", post_data.to_json
    post.code == 201
  end

  def self.silence_check(client, check, description, user, expire_at = nil, log = true, downtime_id = nil)
    event = Event.single("#{client}_#{check}")
    Log.log(user, client, "silence", description, event) if log
    post_data = {:description => description, :owner => user.email, :timestamp => Time.now.to_i }
    post_data[:expire_at] = expire_at unless expire_at.nil?
    post_data[:downtime_id] = downtime_id unless downtime_id.nil?
    post = RestClient.post "#{APP_CONFIG['api']}/stash/silence/#{client}/#{check}", post_data.to_json
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
