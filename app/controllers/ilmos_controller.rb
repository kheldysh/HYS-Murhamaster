require 'digest/md5'

class IlmosController < ApplicationController

skip_before_filter :is_authenticated?

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @waiting_players = @tournament.players.waiting_players

  end

  def new

    @player = Player.new
    tournament = Tournament.find(params[:tournament_id])
    calendar = Calendar.new
    picture = Picture.new
    @registered_already = false

    if logged_in?
      # if logged in, we don't need so much details filled
      user = current_user
      user.players.each do |p|
        if p.tournament == tournament
          @registered_already = true
        end
      end
    else
      # otherwise we create a whole new user
      user = User.new
    end

    @player.user = user
    @player.tournament = tournament
    @player.team = Team.new if tournament.team_game
    @player.user.calendar = calendar
    @player.user.picture = picture
  end


  def create

    @tournament = Tournament.find(params[:tournament_id])
    @player = Player.new(params[:player])
    @player.status = :waiting_approval

    if @tournament.team_game
      logger.info("searching for existing team with name: %s" % params[:team][:name])
      @team = Team.find(:first, :conditions => { :name => params[:team][:name], :tournament_id => @tournament.id } )

      if not @team
        @team = Team.new(params[:team])
      end
    end

    if logged_in?
      # if user is logged in, we need only player alias (and team)
      @user = current_user

      if @tournament.team_game
        @team.tournament = @tournament
        @team.save
        @player.team = @team
      end

      @player.user = @user
      @player.tournament = @tournament
      @player.save

    else
      # if user is not logged in, we create new user with new calendar and such
      username = generate_user(params[:user][:last_name], params[:user][:first_name])
      passwd = generate_passwd(params[:player][:alias])
      @user = User.new(params[:user])
      @user.username = username
      @user.password = passwd

      @calendar = Calendar.new(params[:calendar])
      if params[:picture] and params[:picture][:photo]
        @picture = Picture.new(params[:picture])
      else
        @picture = nil
      end

      User.transaction do
        @user.save

        @calendar.user = @user
        @calendar.save

        if @tournament.team_game
          @team.tournament = @tournament
          @team.save
          @player.team = @team
        end

        @player.user = @user
        @player.tournament = @tournament
        @player.save

        if @picture
          @picture.user = @user
          @picture.save
        end

      end

    end

    IlmoMailer.referee_message(@player).deliver
    begin
      IlmoMailer.player_message(@player, username, passwd).deliver
      @player.registration_email_sent = true
      @player.save
    rescue
      @player.registration_email_sent = false
      @player.save
    end

    flash[:notice] = t('ilmo.registration_received')
    redirect_to root_path

  end


  # rescue ActiveRecord::RecordInvalid => e
    # @player.valid?
    # redirect_to :back
  # end


  def generate_user(last_name, first_name)
    lname_max = 8
    last_name.gsub!(/\W/, '') # leave only alphanumerals (and underscore)
    last_name = last_name.length > lname_max ? last_name[0..lname_max] : last_name # overtly long usernames are bad
    username = last_name.downcase + first_name.downcase[0..0] # last name plus first char of first name
    return User.augment_if_exists(username)
  end

  def generate_passwd(covername) # generates quasi-random, yet memorizable passwd
    covername.gsub!(/\W/, '') # leave only alphanumerals (and underscore)
    cover_slice = covername[0..5].downcase

    time_hash = Digest::MD5.hexdigest(Time.now.to_s+covername+rand().to_s)
    hash_slice_ind = rand(time_hash.length-3)
    hash_slice = time_hash[hash_slice_ind..hash_slice_ind+3]

    # stick cover slice randomly inside hash slice
    cover_slice_ind = rand(hash_slice.length)


    passwd = cover_slice + hash_slice
    return passwd
  end

end

