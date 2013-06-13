require 'spec_helper'

describe AggregatesController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "200"
    end
  end

end
