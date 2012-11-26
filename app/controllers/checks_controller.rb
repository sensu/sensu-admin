class ChecksController < ApplicationController
  def index
    @checks = Check.all
    @server_json = JSON.parse(File.open("config/config.json").read) if File.exists?("config/config.json")
  end

  def submit_check
    resp = Check.submit_check(params[:check], params[:subscribers].split(","))
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def update
  end
end
