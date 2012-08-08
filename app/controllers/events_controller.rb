class EventsController < ApplicationController
  def index
    events = Event.all
    stashes = Stash.stashes
    events.each do |event|
      stashes.each do |stash,value|
        silence, client, check = stash.split("/")
        if silence == "silence"
          if event.client == client
            if check.nil?
              event.attributes['client_silenced'] = value
            elsif event.check == check
              event.attributes['check_silenced'] = value
            end
          end
        end
      end
    end
    @events = events
  end

  def resolve
    resp = Event.manual_resolve(params[:client], params[:check])
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
