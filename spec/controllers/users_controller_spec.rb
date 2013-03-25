require 'spec_helper'

describe UsersController do
  login_user
  
  before :each do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should eq "302"
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.code.should eq "200"
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.code.should eq "200"
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', :id => @user.id
      response.code.should eq "302"
    end
  end

  describe "GET 'update_password'" do
    it "returns http success" do
      get 'update_password', :id => @user.id
      response.code.should eq "302"
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', {:id => @user.id}
      response.code.should eq "302"
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      put 'update', {:id => @user.id, :user => {:role_ids => 1}}
      response.code.should eq "302"
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      # TODO
      # get 'destroy'
      # response.code.should eq "302"
    end
  end

  describe "GET 'activate'" do
    it "returns http success" do
      get 'activate', :id => 1
      response.code.should eq "302"
    end
  end

end
