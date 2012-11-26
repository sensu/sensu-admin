class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :check_for_api, :except => [:setup, :test_api, :update, :new, :create] #Otherwise devise wont sign people in
  before_filter :check_for_settings, :except => :missing

  private

  def check_for_api
    begin
      RestClient.get "#{Setting.api_server}/info"
    rescue Exception => e
      redirect_to(api_setup_path, :alert => "API is down: #{e}")
    end
  end

  def check_for_settings
    REQUIRED_SETTINGS.each do |setting|
      unless Setting.find_by_name(setting)
        redirect_to(settings_missing_path, :notice => "Settings missing #{setting}")
      end
    end
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
end
