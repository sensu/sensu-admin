class DowntimeClient < ActiveRecord::Base
  attr_accessible :downtime_id, :name
  belongs_to :downtime

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :downtime_id
end
