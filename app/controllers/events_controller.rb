class EventsController < ApplicationController
  def index
  end
  def events_table
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
    #
    # Could use a custom sorter here, as Critical is == 2 and Warning == 1
    #
    return_events = []
    events.sort!{|x,y| y.issued <=> x.issued }
    events.each{|event| return_events.push(event) if event.status == 2}
    events.each{|event| return_events.push(event) if event.status == 1}
    events.each{|event| return_events.push(event) if event.status != 2 && event.status != 1}
    @events = return_events
    render :json => { :data => render_to_string(:action => '_table', :layout => false) }
  end

  def resolve
    puts "resolve params are: #{params.inspect}"
    resp = Event.manual_resolve(params[:client], params[:check], current_user)
    puts "controller response for resolve is #{resp}"
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def silence_client
    expire_at = nil
    if !params[:expire_at_time].blank? && !params[:expire_at_date].blank?
      expire_at = Time.parse("#{params[:expire_at_date]} #{params[:expire_at_time]}")
    end
    puts "silence_client params are: #{params.inspect}"
    resp = Event.silence_client(params[:client], params[:description], current_user, expire_at)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def silence_check
    expire_at = nil
    if !params[:expire_at_time].blank? && !params[:expire_at_date].blank?
      expire_at = Time.parse("#{params[:expire_at_date]} #{params[:expire_at_time]}")
    end
    puts "silence_check params are: #{params.inspect}"
    resp = Event.silence_check(params[:client], params[:check], params[:description], current_user, expire_at)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def unsilence_client
    resp = Event.unsilence_client(params[:client], current_user)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def unsilence_check
    resp = Event.unsilence_check(params[:client], params[:check], current_user)
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
