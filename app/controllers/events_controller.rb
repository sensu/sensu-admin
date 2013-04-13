class EventsController < ApplicationController
  before_filter :find_events, :only => [:index, :events_table ]
  before_filter :prepare_for_mobile

  def index
  end

  def events_table
    events_datatable = []
    @events.each_with_index do |event, i|
      client_silenced = event.client_silenced
      check_silenced = event.check_silenced
      if Setting.use_environments?
        events_datatable << [
         event.sort_val,
         render_to_string(:action => "_status", :formats => [:html], :layout => false, :locals => { :event => event }),
         event.client_attributes['environment'],
         event.client,
         event.check,
         render_to_string(:action => "_output", :formats => [:html], :layout => false, :locals => { :event => event }),
         render_to_string(:action => "_actions", :formats => [:html], :layout => false, :locals => { :event => event, :i => i, :client_silenced => client_silenced, :check_silenced => check_silenced}),
         render_to_string(:action => "_issued", :formats => [:html], :layout => false, :locals => { :event => event }),
         "<div class = 'moreinfo' style = 'cursor: pointer; position: absolute; display: block; height: 25px; width: 25px;' index_id='#{i}' misc='#{event.client}_#{event.check}'><i style='padding-right: 10px;' class='icon-zoom-in'></i></div>"
        ]
      else
        events_datatable << [
         event.sort_val,
         render_to_string(:action => "_status", :formats => [:html], :layout => false, :locals => { :event => event }),
         event.client,
         event.check,
         render_to_string(:action => "_output", :formats => [:html], :layout => false, :locals => { :event => event }),
         render_to_string(:action => "_actions", :formats => [:html], :layout => false, :locals => { :event => event, :i => i, :client_silenced => client_silenced, :check_silenced => check_silenced}),
         render_to_string(:action => "_issued", :formats => [:html], :layout => false, :locals => { :event => event }),
         "<div class = 'moreinfo' style = 'cursor: pointer; position: absolute; display: block; height: 25px; width: 25px;' index_id='#{i}' misc='#{event.client}_#{event.check}'><i style='padding-right: 10px;' class='icon-zoom-in'></i></div>"
        ]
      end
    end
    respond_to do |format|
      format.json do
        render :json => { "aaData" => events_datatable}
      end
    end
  end

  def modal_data
    event = Event.single(params[:event_query])
    if event
      render :json => {:data => render_to_string(:action => "_modal_data", :layout => false, :locals => {:event => event, :i => params[:i]})}
    else
      render :json => {:data => false }
    end
  end

  def modal_silence
    event = Event.single(params[:event_query])
    render :json => {:data => render_to_string(:action => "_modal_silence", :layout => false, :locals => {:event => event, :i => params[:i], :type => params[:t]})}
  end

  def resolve
    resp = Event.manual_resolve(params[:client], params[:check], current_user)
    Event.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 202).to_s }
      format.mobile { render :json => (resp.code == 202).to_s }
    end
  end

  def check_min_desc(description)
    min_length = Setting.min_desc_length.to_i || 0
    if description.length < min_length
      respond_to do |format|
        format.json { render :json => {:code => 1, :msg => "Your comment must be at least #{min_length} characters long"} }
        format.mobile { render :json => {:code => 1, :msg => "Your comment must be at least #{min_length} characters long"} }
      end
      return false
    end 
    return true
  end
 
  def silence_client
    unless check_min_desc(params[:description])
      return
    end
    expire_at = nil
    if !params[:expire_at_time].blank? && !params[:expire_at_date].blank?
      expire_at = Time.parse("#{params[:expire_at_date]} #{params[:expire_at_time]}")
    end
    params[:description] = "No reason given" if params[:description].empty?
    resp = Event.silence_client(params[:client], params[:description], current_user, expire_at)
    Stash.refresh_cache
      
    respond_to do |format|
      format.json { render :json => (resp.code == 201) ? {'code' => 0} : {'code' => resp.code, 'msg' => 'Error silencing client'} }
      format.mobile { render :json => (resp.code == 201).to_s }
    end
  end

  def silence_check
    unless check_min_desc(params[:description])
      return
    end
    expire_at = nil
    if !params[:expire_at_time].blank? && !params[:expire_at_date].blank?
      expire_at = Time.parse("#{params[:expire_at_date]} #{params[:expire_at_time]}")
    end
    params[:description] = "No reason given" if params[:description].empty?
    resp = Event.silence_check(params[:client], params[:check], params[:description], current_user, expire_at)
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 201) ? {'code' => 0} : {'code' => resp.code, 'msg' => 'Error silencing check'} }
      format.json { render :json => (resp.code == 201).to_s }
      format.mobile { render :json => (resp.code == 201).to_s }
    end
  end

  def unsilence_client
    resp = Event.unsilence_client(params[:client], current_user)
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 204).to_s }
      format.mobile { render :json => (resp.code == 204).to_s }
    end
  end

  def unsilence_check
    resp = Event.unsilence_check(params[:client], params[:check], current_user)
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 204).to_s }
      format.mobile { render :json => (resp.code == 204).to_s }
    end
  end

  private

  def find_events
    @events = Event.all_with_cache
  end
end
