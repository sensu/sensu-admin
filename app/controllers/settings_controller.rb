class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :manage, Setting.all
    @sensu_api_server = Setting.find_by_name("api_server")
    @use_environments = Setting.find_by_name("use_environments")
    @configure_server = Setting.find_by_name("configure_server")
  end

  def missing
  end

  def create
    puts params.inspect
    @setting = Setting.new(:name => params[:name], :value => params[:value])
    if @setting.save!
      redirect_to(settings_path, :notice => "Successfully created")
    end
  end

  def update
    @setting = Setting.find(params[:id])
    puts "Setting: #{@setting.name}"
    @setting.value = params[:setting][:value]
    puts "Setting value: #{@setting.value}"
    if @setting.save!
      Setting.flush_cache
      redirect_to(settings_path, :notice => "Successfully updated")
    end
  end
end
