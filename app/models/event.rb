class Event < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  self.site = "http://localhost:4567/"

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
end
