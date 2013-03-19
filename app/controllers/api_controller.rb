class ApiController < ApplicationController
  def status
    @api = Api.status
    parse_api_status(@api)
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


  private

  def parse_api_status(api)
    @sensu_version = api.sensu['version']
    if Gem::Version.new(@sensu_version) < Gem::Version.new("0.9.11")
      @redis_health = api.health['redis']
      @rabbitmq_health = api.health['rabbitmq']
    else  
      @redis_health = api.redis['connected'] ? "ok" : "failed"
      @rabbitmq_health = api.rabbitmq['connected'] ? "ok" : "failed"
    end

    return @sensu_version, @redis_health, @rabbitmq_health
  end

end
