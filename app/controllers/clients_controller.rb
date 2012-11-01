class ClientsController < ApplicationController
  before_filter :prepare_for_mobile

  def index
    @clients = Client.all_with_cache
  end

  def destroy
    resp = Client.destroy(params[:id])
    Client.refresh_cache
    respond_to do |format|
      format.json { render :json => {:data => (resp == 202).to_s}.to_json }
      format.mobile { render :json => {:data => (resp == 202).to_s}.to_json }
    end
  end
end
