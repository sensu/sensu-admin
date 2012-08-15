class DowntimesController < ApplicationController
  def index
    @active_downtime = Downtime.active
    @future_downtime = Downtime.future
    #@past_downtime = Downtime.past Would need to paginate this.
  end
end
