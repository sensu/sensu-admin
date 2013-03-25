require 'spec_helper'

describe DowntimesController do
  login_user
  # TODO: the commented examples in this suite need a mocked version of Client

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      # get 'new'
      # response.code.should eq "302"
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      # get 'create'
      # response.code.should eq "302"
    end
  end

  describe "GET 'old_downtimes'" do
    it "returns http success" do
      get 'old_downtimes'
      response.code.should eq "302"
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      # get 'show'
      # response.code.should eq "302"
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {:id => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      downtime = FactoryGirl.create(:downtime)
      downtime_client = FactoryGirl.build(:downtime_client)
      downtime_client.downtime_id = downtime.id
      downtime_client.save
      setting = FactoryGirl.create(:setting)
      # get 'update', {:id => downtime.id}
      # response.code.should eq "302"
    end
  end

  describe "GET 'force_complete'" do
    it "returns http success" do
      get 'force_complete'
      response.code.should eq "302"
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy', {:id => 1}
      response.code.should eq "302"
    end
  end

end
