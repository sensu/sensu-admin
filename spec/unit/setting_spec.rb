require 'spec_helper'

describe Setting do

  it "should return the api server" do
    api_server = Setting.api_server
    api_server.should_not be_nil
    api_server.should_not be_false
    Setting.api_server.should_not be_nil
  end

  it "should return true if environments are in use" do
    env_setting = Setting.find_by_name("use_environments")
    Setting.use_environments?.should be_false
  end

end
