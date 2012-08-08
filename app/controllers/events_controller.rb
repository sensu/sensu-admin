class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def resolve
    resp = Event.manual_resolve(params[:client], params[:check])
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
