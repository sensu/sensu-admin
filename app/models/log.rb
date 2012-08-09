class Log < ActiveRecord::Base
  attr_accessible :check, :client, :environment, :output, :silence_type, :status, :user_id
  belongs_to :user
end
