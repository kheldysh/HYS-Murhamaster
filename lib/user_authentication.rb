module UserAuthentication
  
  protected
  
  def log_user_in(user)
    session[:user_id] = user.id if user
    session[:admin] = user.admin if user
  end
  
  def log_user_out!
    session[:user_id] = nil
  end
  
  def current_user
    User.find(session[:user_id])
  end
  
  def logged_in?
    session[:user_id]
  end
  
end
