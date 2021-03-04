class SessionsController < ApplicationController
  skip_before_action :require_login

  def login
    redirect_to root_path if current_user
  end

  def create
    google_user = GoogleSignIn::Identity.new(flash["google_sign_in_token"])

    if google_user.email_address !~ /@gpmail.org$/
      flash[:error] = "Forbidden: #{google_user.email_address}. Please log in with a valid gpmail account."
      redirect_to signin_path
    else
      # Set profile_img for the sidebar
      user = User.from_google_login(google_user)
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
