class ClientsController < ApplicationController
  before_filter :prepare_for_mobile

  def index
    @clients = Client.all_with_cache
  end

  def modal_data
    client = Client.find(params[:client_query])
    if client
      render :json => {:code => 0, :data => render_to_string(:action => "_modal", :layout => false, :locals => {:client => client})}
    else
      render :json => {:code => 1, :msg => "Could not find client #{params[:client_query]}"}
    end
  end
  
  def delete_client
    resp = Client.destroy(params[:key])
    Client.refresh_cache
    Event.refresh_cache
    respond_to do |format|
      format.json { render :json => {:data => (resp.code == 202).to_s}.to_json }
      format.mobile { render :json => {:data => (resp.code == 202).to_s}.to_json }
    end
  end
end
