require 'spec_helper'

describe SettingsController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "GET 'missing'" do
    it "returns http success" do
      get 'missing'
      response.code.should eq "302"
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.code.should eq "302"
    end
  end

  describe "PUT 'update'" do
    it "returns http success" do
      setting = FactoryGirl.create(:setting) 
      put 'update', {:id => 1, :setting => {:name => setting.name}}
      response.code.should eq "302"
    end
  end

end
