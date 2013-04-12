require 'spec_helper'

describe Api::ApiController do
  login_user

  describe "GET 'status'" do
    it "returns http success" do
      get 'status'
      response.code.should eq "200"
    end
  end

  describe "GET 'time'" do
    it "returns http success" do
      get 'time'
      response.code.should eq "200"
    end
  end

  describe "GET 'setup'" do
    it "returns http success" do
      get 'setup'
      response.code.should eq "200"
    end
  end

  describe "GET 'test_api'" do
    it "returns http success" do
      get 'test_api'
      response.code.should eq "200"
    end
  end

end
