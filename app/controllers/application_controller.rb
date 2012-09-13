class ApplicationController < ActionController::Base
  include UserAuthentication # /lib/user_authentication.rb

  protect_from_forgery

  helper :all # include all helpers, all the time

  before_filter :is_authenticated?
  before_filter :set_locale

  protected

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    print "locale: ", session[:locale]
    I18n.locale = session[:locale] || I18n.default_locale

    locale_path = "#{LOCALES_DIRECTORY}/#{I18n.locale}.yml"

    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end

  rescue Exception => err
    logger.error err
    flash.now[:notice] = "#{I18n.locale} translation not possible"

    I18n.load_path = [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  def show_image(picture)
    send_data picture.data, :type => picture.content_type, :disposition => 'inline', :filename => picture.name
  end

  def is_authenticated?
    if logged_in?
      logger.info "auth confirmed: user_id: #{current_user.id}"
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

  def is_referee?

    if not logged_in?
      redirect_to root_path
      return false
    end

    if current_user.admin
      return true
    end

    @active_tournaments = Tournament.not_finished
    @active_tournaments.each do |tournament|
      current_user.referees.each do |referee|
        if referee.tournament = tournament
          return true
        end
      end
    end
    redirect_to root_path
    return false
  end


  def is_owner_or_referee?
    # remember to compare string against string
    if current_user.id.to_s == params[:user_id] or is_referee?
      return true
    end
  end

end
