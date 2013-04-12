require 'spec_helper'

describe EventsController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "200"
    end
  end

  describe "GET 'events_table'" do
    it "returns http success" do
      pending
      get 'events_table', {:client => 1}
      response.code.should eq "200"
    end
  end

  describe "GET 'modal_data'" do
    it "returns http success" do
      get 'modal_data', {:client => 1}
      response.code.should eq "200"
    end
  end

  describe "GET 'resolve'" do
    it "returns http success" do
      # todo
      # get 'resolve', {:client => 1, :check => 1}
      # response.code.should eq "200"
    end
  end

  describe "GET 'silence_client'" do
    it "returns http success" do
      # todo
      # get 'silence_client', {:client =>1}
      # response.code.should eq "200"
    end
  end

  describe "GET 'silence_check'" do
    it "returns http success" do
      # todo
      # get 'silence_check', {:client => 1, :check => 1, :description => "this is a test description", :user => User.first}
      # response.code.should eq "200"
    end
  end

  describe "GET 'unsilence_check'" do
    it "returns http success" do
      # todo
      # get 'unsilence_check', {:client => 1, :check => 1}
      # response.code.should eq "200"
    end
  end

  describe "GET 'unslience_client'" do
    it "returns http success" do
      # todo
      # get 'unslience_client', {:client => 1}
      # response.code.should eq "200"
    end
  end

end
