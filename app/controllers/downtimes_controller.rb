class DowntimesController < ApplicationController
  before_filter :find_downtime, :except => [:index, :new, :create]

  def index
    @active_downtime = Downtime.active
    @future_downtime = Downtime.future
    #@past_downtime = Downtime.past Would need to paginate this.
  end

  def new
    @downtime = Downtime.new
  end

  def create
    @downtime = Downtime.new(params[:downtime])
    if @downtime.save
      redirect_to(@downtime, :notice => "Successfully created")
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @downtime.destroy
    redirect_to(downtimes_path, :notice => "Downtime successfully deleted")
  end

  private
  def find_downtime
    @downtime = Downtime.find(params[:id])
  end
end
