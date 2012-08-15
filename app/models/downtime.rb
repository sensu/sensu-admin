class Downtime < ActiveRecord::Base
  attr_accessible :description, :name, :start_time, :stop_time, :user_id, :processed, :completed
  attr_writer :current_step

  belongs_to :user

  has_many :downtime_checks
  has_many :downtime_clients

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :user_id
  validates_presence_of :downtime_clients

  validate :validates_stop_time_of, :on => :create

  scope :active, lambda { where("? BETWEEN start_time AND stop_time", DateTime.now) }
  scope :past, lambda { where("? > stop_time", DateTime.now) }
  scope :future, lambda { where("start_time > ?", DateTime.now) }
  scope :all_processed, where(:processed => true)
  scope :not_processed, where(:processed => false)
  scope :all_completed, where(:completed => true)
  scope :not_completed, where(:completed => false)

  #def self.silence_check(client, check, description, user, expire_at = nil)
  #def self.silence_client(client, description, user, expire_at = nil)

  def self.process_downtimes
    run_expired_stashes = false

    Downtime.active.not_processed.each do |downtime|
      puts "Processing downtime #{downtime.id}"
      if downtime.downtime_checks.empty?
        downtime.downtime_clients.each do |client|
          puts "Silencing client #{client.name} for downtime #{downtime.id}"
          Event.silence_client(client.name, "Scheduled downtime(#{downtime.id},#{downtime.name}) until #{downtime.stop_time} by #{downtime.user.email}", downtime.user, downtime.stop_time, false)
        end
      else
        downtime.downtime_clients.each do |client|
          downtime.downtime_checks.each do |check|
            puts "Silencing check #{check.name} on #{client.name} for downtime #{downtime.id}"
            Event.silence_check(client.name, check.name, "Scheduled downtime(#{downtime.id},#{downtime.name}) until #{downtime.stop_time} by #{downtime.user.email}", downtime.user, downtime.stop_time, false)
          end
        end
      end
      puts "Marking #{downtime.name} as processed"
      downtime.process
    end

    Downtime.not_completed.past.each do |downtime|
      puts "Marking #{downtime.name} as completed"
      run_expired_stashes = true
      downtime.complete
    end

    if run_expired_stashes
      puts "Clearing stashes in process_downtimes"
      Stash.clear_expired_stashes
    end
  end

  def active?
    Time.now > self.start_time && Time.now < self.stop_time
  end

  def processed?
    self.processed
  end

  def completed?
    self.completed
  end

  def process
    self.update_attributes(:processed => true)
  end

  def complete
    self.update_attributes(:completed => true)
  end

  private

  def validates_stop_time_of
    errors.add(:stop_time, "end of date is not in the future.") if Time.now > self.stop_time
  end
end
