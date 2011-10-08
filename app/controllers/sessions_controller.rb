class SessionsController < ApplicationController

 skip_before_filter :is_authenticated?, :only => [ :create ]

  def create

    if logged_in?
      redirect_to root_path
    else
      authenticated_user = User.authenticate(params[:user][:username], params[:user][:password])

      if authenticated_user
        log_user_in(authenticated_user)
        authenticated_user.last_login = DateTime.now
        logger.info "user logged in!"
        redirect_to root_path
      else
        flash[:error] = "Login failed, check username and password."
        logger.info "login failed!"
        redirect_to login_path
      end

    end

  end


  def destroy
    reset_session
    redirect_to root_path
  end

end

