# encoding: utf-8
class UsersController < ApplicationController

  skip_before_filter :is_authenticated?, :only => [ :index, :new, :create ]
  before_filter :own_data?, :except => [ :index, :new, :create ]
  before_filter :is_admin?, :only => [:destroy]

  def index
    flash.keep(:notice)
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    calendar = Calendar.new
    @user.calendar = calendar
    if @user.save
      flash[:notice] = 'Käyttäjä luotiin onnistuneesti.'
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user] && params[:user].include?(:password) && params[:user].include?(:password_confirmation)
      params[:user][:password] = User.hash_plaintext_password(params[:user][:password])
      params[:user][:password_confirmation] = User.hash_plaintext_password(params[:user][:password_confirmation])
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = 'Käyttäjätiedot päivitetty.'
      redirect_to(@user)
    else
      flash[:notice] = 'Päivitys ei onnistunut.'
      render :action => "edit"
    end
  end

  def reset_password
    @user = User.find(params[:id])
    new_pass = @user.reset_password
    msg = ManagementMailer.create_password_reset_message(@user, new_pass)
    begin
      ManagementMailer.deliver(msg)
      flash[:notice] = "Salasanan uudelleenasetus onnistui! Salasana on lähetetty pelaajalle sähköpostitse."
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Salasanaa ei voitu lähettää sähköpostitse. Pelaajan uusi salasana on #{new_pass}"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  # filter for preventing users from seeing others' data
  def own_data?
    unless params[:id] == session[:user_id].to_s || current_user.admin
      redirect_to root_path
    end
  end

end
