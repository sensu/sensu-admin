module FakeSensuMacros

  def reset_fake_sensu!
    api_setting = Setting.find_by_name("api_server")
    api_path = api_setting.value
    RestClient.get("#{api_path}/reset")
  end

end
