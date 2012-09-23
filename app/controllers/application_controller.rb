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
    redirect_to login_path unless logged_in?
  end

  def is_admin?
    redirect_to root_path unless current_user.admin
  end

  def is_referee?
    if current_user.admin
      return true
    end
    active_tournaments = Tournament.not_finished
    active_tournaments.each do |tournament|
      current_user.referees.each do |referee|
        if referee.tournament == tournament
          return true
        end
      end
    end
    redirect_to root_path
  end

  def is_owner_or_referee?
    # remember to compare string against string
    unless current_user.id.to_s == params[:user_id] or is_referee?
      redirect_to root_path
    end
  end

end
