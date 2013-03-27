class StashesController < ApplicationController
  before_filter :prepare_for_mobile

  def index
    api = Api.status
    @sensu_version  =  api.sensu['version']
    @stashes = Stash.stashes
  end

  def create_stash
    attributes = {:description => "Manual stash creation", :owner => current_user.email, :timestamp => Time.now.to_i }
    unless params[:date].empty? || params[:time].empty?
      attributes.merge!({:expire_at => Time.parse("#{params[:date]} #{params[:time]}")})
    end
    if params[:description].empty?
      attributes.merge!({:description => "Manual stash creation"})
    else
      attributes.merge!({:description => params[:description]})
    end
    resp = Stash.create_stash(params[:key], attributes)
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 201).to_s }
    end
  end

  def delete_stash
    resp = Stash.delete_stash(params[:key])
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => (resp.code == 204).to_s }
      format.mobile { render :json => (resp.code == 204).to_s }
    end
  end

  def delete_all_stashes
    resp = Stash.delete_all_stashes
    Stash.refresh_cache
    respond_to do |format|
      format.json { render :json => resp.to_s }
      format.mobile { render :json => resp.to_s }
    end
  end
end
