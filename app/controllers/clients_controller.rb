class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def destroy
    cli_resp = Client.delete(params[:id])
    resp = cli_resp.code == 202
    respond_to do |format|
      format.json { render :json => {:data => resp}.to_json }
    end
  end
end
