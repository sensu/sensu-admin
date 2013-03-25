require 'spec_helper'

describe StashesController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

end
