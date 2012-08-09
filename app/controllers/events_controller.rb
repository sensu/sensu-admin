class EventsController < ApplicationController
  def index
    events = Event.all
    stashes = Stash.stashes.select {|stash, value| stash =~ /silence/}
    puts "stashes: #{stashes.inspect}"
    events.each do |event|
      if stashes.include?("silence/#{event.client}")
        event.attributes['client_silenced'] = stashes["silence/#{event.client}"]
      end
      if stashes.include?("silence/#{event.client}/#{event.check}")
        event.attributes['check_silenced'] = stashes["silence/#{event.client}/#{event.check}"]
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

  def silence_client
    resp = Event.silence_client(params[:client], params[:description], current_user.email)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def silence_check
    resp = Event.silence_check(params[:client], params[:check], params[:description], current_user.email)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
