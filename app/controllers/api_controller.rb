class ApiController < ApplicationController
  def status
    render :json => { :data => render_to_string(:action => '_apistatus', :layout => false) }
  end

  def time
    render :json => { :data => render_to_string(:action => '_time', :layout => false) }
  end

  def setup
    @sensu_api_server = Setting.find_by_name("api_server")
  end

  def test_api
    begin
      resp = RestClient.get "#{params[:url]}/info"
      render :json => { :data => { :status => 'ok', :message => resp.body }}, :layout => false
    rescue Exception => e
      render :json => { :data => { :status => 'fail', :message => e.inspect.to_s }}, :layout => false
    end
  end
end
