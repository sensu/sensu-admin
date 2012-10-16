class Log < ActiveRecord::Base
  attr_accessible :check, :client, :environment, :output, :silence_type, :status, :user_id, :action_type, :reason
  belongs_to :user

  def self.log(user, client_name, type, reason = nil, event = nil)
    client = Client.find(client_name)
    if event.nil?
      #Client only event
      user.logs.create!(:client => client.name,
                        :silence_type => "client",
                        :action_type => type,
                        :reason => reason,
                        :environment => client.environment)
    else
      user.logs.create!(:client => client.name,
                        :check => event.check,
                        :silence_type => "event",
                        :action_type => type,
                        :reason => reason,
                        :environment => client.environment,
                        :output => event.output,
                        :status => event.status)
    end
  end
end
