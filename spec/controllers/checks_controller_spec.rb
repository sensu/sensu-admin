require 'spec_helper'

describe ChecksController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "GET 'submit_check'" do
    it "returns http success" do
      get 'submit_check', {:check => 1}
      response.code.should eq "302"
    end
  end

end
