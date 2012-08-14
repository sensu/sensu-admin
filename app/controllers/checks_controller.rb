class ChecksController < ApplicationController
  def index
    @checks = Check.all
  end

  def submit_check
    resp = Check.submit_check(params[:check], params[:subscribers].split(","))
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
