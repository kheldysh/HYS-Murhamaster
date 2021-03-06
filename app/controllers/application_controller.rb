class ApplicationController < ActionController::Base
  include UserAuthentication # /lib/user_authentication.rb

  protect_from_forgery

  helper :all # include all helpers, all the time

  before_filter :is_authenticated?
  before_filter :set_locale

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale

    locale_path = "#{LOCALES_DIRECTORY}/#{I18n.locale}.yml"

    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end

  rescue Exception => err
    logger.error err
    I18n.load_path = [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  def is_authenticated?
    logger.info("session data: #{session.to_s}")
    logger.info("checking authentication for user #{current_user.username rescue "unknown"}")
    redirect_to login_path unless logged_in?
    true
  end

  def is_admin?
    redirect_to :controller => :users, :action => :show, :id => session[:user_id] unless current_user.admin
    true
  end

  def is_referee?
    tournament = Tournament.find(params[:tournament_id])
    if current_user.is_referee_for?(tournament) && tournament.is_relevant_for_referee?
      logger.info("user #{current_user.username} accessed a referee-restricted page")
      true
    else
      logger.info("user #{current_user.username} tried to access referee-restricted page without permission")
      redirect_to(root_path)
    end
  end

  def is_owner_or_referee?
    # remember to compare string against string
    unless current_user.id.to_s == params[:user_id] or is_referee?
      redirect_to root_path
    end
    true
  end

  def redirect_to(options = {}, response_status = {})
    logger.info("Redirected by #{caller(1).first rescue "unknown"}")
    super(options, response_status)
  end
end
