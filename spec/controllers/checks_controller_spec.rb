require 'spec_helper'

describe ChecksController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "200"
    end
  end

  describe "GET 'submit_check'" do
    it "returns http success" do
      # todo
      # get 'submit_check', {:check => 1}
      # response.code.should eq "200"
    end
  end

end
