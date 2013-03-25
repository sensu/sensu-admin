require 'spec_helper'

describe EventsController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "GET 'events_table'" do
    it "returns http success" do
      get 'events_table', {:client => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'modal_data'" do
    it "returns http success" do
      get 'modal_data', {:client => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'resolve'" do
    it "returns http success" do
      get 'resolve', {:client => 1, :check => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'silence_client'" do
    it "returns http success" do
      get 'silence_client', {:client =>1}
      response.code.should eq "302"
    end
  end

  describe "GET 'silence_check'" do
    it "returns http success" do
      get 'silence_check', {:client => 1, :check => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'unsilence_check'" do
    it "returns http success" do
      get 'unsilence_check', {:client => 1, :check => 1}
      response.code.should eq "302"
    end
  end

  describe "GET 'unslience_client'" do
    it "returns http success" do
      # TODO
      # get 'unslience_client', {:client => 1}
      # response.code.should eq "302"
    end
  end

end
