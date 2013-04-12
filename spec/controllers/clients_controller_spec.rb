require 'spec_helper'

describe ClientsController do
  login_user
  
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "200"
    end
  end

  describe "DELETE 'destroy'" do
    it "returns http success" do
      # todo: no template
      # delete 'destroy', {:id => 1}
      # response.code.should eq "202"
    end
  end

end
