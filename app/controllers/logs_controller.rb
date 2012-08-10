class LogsController < ApplicationController
  def index
    @logs = Log.find(:all, :order => 'created_at DESC')
  end
end
