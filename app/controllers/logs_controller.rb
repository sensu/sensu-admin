class LogsController < ApplicationController
  def index
    @logs = Log.paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
  end
end
