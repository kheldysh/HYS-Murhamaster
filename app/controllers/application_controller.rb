class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
 
  include UserAuthentication # /lib/user_authentication.rb
  
  before_filter :is_authenticated?
  
  protected
  
  def show_image(picture)
    send_data picture.data, :type => picture.content_type, :disposition => 'inline', :filename => picture.name
  end
  
  def is_authenticated?
    if logged_in?
      logger.info "auth confirmed"
      return true
    else
      logger.info "no login, redirecting"
      redirect_to login_path
    end
  end
  
  # filter for preventing users from seeing others' data
  def own_data?
    if params[:id] == session[:user_id].to_s() or session[:admin]
      return true
    else
      redirect_to :controller => :users, :action => :show, :id => session[:user_id]
    end
  end

  def is_admin?
    if session[:admin]
      logger.info "admin!"
      return true
    else
      logger.info "not admin!"
      redirect_to :controller => :users, :action => :show, :id => session[:user_id]
    end
  end
end

