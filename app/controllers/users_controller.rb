# encoding: utf-8
class UsersController < ApplicationController

  skip_before_filter :is_authenticated?, :only => [ :index, :new, :create ]
  before_filter :own_data?, :except => [ :index, :new, :create ]
  before_filter :is_admin?, :only => [:destroy]

  def index
    @user = User.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
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

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if params[:user] and params[:user].include? :password and params[:user].include? :password_confirmation
      params[:user][:password] = User.hash_plaintext_password(params[:user][:password])
      params[:user][:password_confirmation] = User.hash_plaintext_password(params[:user][:password_confirmation])

    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Käyttäjätiedot päivitetty.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
