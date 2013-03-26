def set_current_user(user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id]) if !session[:user_id].nil?
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end