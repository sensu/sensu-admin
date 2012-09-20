class DowntimesController < ApplicationController
  respond_to :html
  before_filter :find_downtime, :except => [:index, :new, :create, :old_downtimes, :force_complete]
  before_filter :find_clients, :except => [:index]
  before_filter :find_checks, :except => [:index]

  def index
    @active_downtime = Downtime.active.not_completed.all_processed
    @future_downtime = Downtime.not_completed.not_processed
    #@past_downtime = Downtime.past Would need to paginate this. For now its on its own page.
  end

  def new
    @downtime = Downtime.new
  end

  def create
    Downtime.transaction do
      dt = params['downtime']
      @downtime = Downtime.new
      @downtime.assign_attributes({
        :name => dt['name'],
        :description => dt['description'],
        :start_time => Time.parse("#{dt['begin_date']} #{dt['begin_time']}"),
        :stop_time => Time.parse("#{dt['end_date']} #{dt['end_time']}"),
        :user_id => current_user.id
      })
      unless dt['client_ids'].nil?
        dt['client_ids'].each do |client_id|
          next if client_id.blank?
          @downtime.downtime_clients.build(:name => client_id)
        end
      end
      unless dt['check_ids'].nil?
        dt['check_ids'].each do |check_id|
          next if check_id.blank?
          @downtime.downtime_checks.build(:name => check_id)
        end
      end
    end
    if @downtime.save!
      redirect_to(downtimes_path(@downtime), :notice => "Successfully created")
    end
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end

  def old_downtimes
    @old_downtimes = Downtime.past
  end

  def show
  end

  def edit
  end

  def update
    Downtime.transaction do
      dt = params['downtime']
      @downtime.assign_attributes({
        :name => dt['name'],
        :description => dt['description'],
        :start_time => Time.parse("#{dt['begin_date']} #{dt['begin_time']}"),
        :stop_time => Time.parse("#{dt['end_date']} #{dt['end_time']}"),
        :user_id => current_user.id
      })
      unless dt['client_ids'].nil?
        @downtime.downtime_clients.destroy_all
        dt['client_ids'].each do |client_id|
          next if client_id.blank?
          @downtime.downtime_clients.build(:name => client_id)
        end
      end
      unless dt['check_ids'].nil?
        @downtime.downtime_checks.destroy_all
        dt['check_ids'].each do |check_id|
          next if check_id.blank?
          @downtime.downtime_checks.build(:name => check_id)
        end
      end
      if @downtime.save!
        redirect_to(downtimes_path, :notice => "Downtime successfully updated.")
      end
    end
  rescue ActiveRecord::RecordInvalid
      render :action => "edit"
  end

  def force_complete
    Downtime.force_complete(params[:downtime_id])
    redirect_to(downtimes_path, :notice => "Downtime successfully completed")
  end

  def destroy
    @downtime.destroy
    redirect_to(downtimes_path, :notice => "Downtime successfully deleted")
  end

  private

  def find_downtime
    @downtime = Downtime.find(params[:id])
  end

  def find_clients
    @clients = Client.all
  end

  def find_checks
    @checks = Check.all
  end
end
