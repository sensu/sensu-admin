require 'spec_helper'

describe ClientsController do
  login_user
  
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "DELETE 'destroy'" do
    it "returns http success" do
      delete 'destroy', {:id => 1}
      response.code.should eq "302"
    end
  end

end
