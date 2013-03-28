module DeviseMacros
  def sign_in_user(user)
    visit '/users/sign_in'
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Sign in"
  end

  def set_api
    visit '/api/setup' 
    fill_in "Sensu API Server url", :with => "http://foo:bar@33.33.33.11:4567"
    click_link_or_button "save_api_server"
  end
end
