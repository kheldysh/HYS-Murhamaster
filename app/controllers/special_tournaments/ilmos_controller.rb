require 'digest/md5'

class SpecialTournaments::IlmosController < ApplicationController

skip_before_filter :is_authenticated?, :except => :index
before_filter :is_referee?, :only => :index

  def new
    @player = Player.new
    tournament = Tournament.find(params[:special_tournament_id])
    calendar = Calendar.new
    picture = Picture.new

    user = User.new
    user.calendar = calendar
    user.picture = picture

    @player.user = user
    @player.tournament = tournament
  end

  def create
    @tournament = Tournament.find(params[:special_tournament_id])
    @player = Player.new(params[:player])
    @player.status = :waiting_approval

    # if user is not logged in, we create new user with new calendar and such
    username = generate_username(@tournament.title, params[:user][:last_name], params[:user][:first_name])
    passwd = generate_passwd(params[:user][:last_name])
    @user = User.new(params[:user])
    @user.username = username
    @user.password = passwd

    @calendar = Calendar.new(params[:calendar])
    @picture = Picture.new(params[:picture]) if params[:picture] and params[:picture][:photo]

    @user.save

    @calendar.user = @user
    @calendar.save

    @player.user = @user
    @player.tournament = @tournament
    @player.save

    if @picture
      @picture.user = @user
      @picture.save
    end

    IlmoMailer.referee_message(@player).deliver if @player.tournament.send_registration_announcements_to_referees
    render :registration_complete
  end

  def generate_username(tournament_title, last_name, first_name)
    # leave only alphanumerals (and underscore)
    username = [tournament_title, first_name, last_name].map { |name| name.gsub(/\W/, '').downcase }.join('_')
    User.augment_if_exists(username)
  end

  def generate_passwd(covername) # generates quasi-random, yet memorizable passwd
    Digest::MD5.hexdigest(Time.now.to_s+covername+rand().to_s)
  end

  def is_referee?
    return true if current_user.admin
    tournament = Tournament.find(params[:id])
    tournament.referees.each do |ref|
      if current_user.referees.include?(ref)
        return true
      end
    end
    redirect_to root_path
  end

end

