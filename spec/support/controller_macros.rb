module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) 
    end
  end

  def login_user
    before :all do
      load "#{Rails.root}/db/seeds.rb" 
    end

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      user.add_role :admin
      sign_in user
    end
  end
end
