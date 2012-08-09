class EventsController < ApplicationController
  def index

    events = Event.all
    stashes = Stash.stashes.select {|stash, value| stash =~ /silence/}
    cli = {}
    Client.all.each do |client|
      cli[client.attributes['name']] = client.attributes
    end
    events.each do |event|
      if stashes.include?("silence/#{event.client}")
        event.client_silenced = stashes["silence/#{event.client}"]
      end
      if stashes.include?("silence/#{event.client}/#{event.check}")
        event.check_silenced = stashes["silence/#{event.client}/#{event.check}"]
      end
      event.client_attributes = cli[event.client]
    end
    @events = events.sort!{|x,y| x.status <=> y.status}
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

  def unsilence_client
    resp = Event.unsilence_client(params[:client])
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def unsilence_check
    resp = Event.unsilence_check(params[:client], params[:check])
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
