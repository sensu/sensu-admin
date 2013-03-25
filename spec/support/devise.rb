def sign_in_user(user)
  visit '/users/sign_in'
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button "Sign in"
end

def fill_out_api
  visit '/settings' 
end
