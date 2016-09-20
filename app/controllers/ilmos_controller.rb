require 'digest/md5'

class IlmosController < ApplicationController

skip_before_filter :is_authenticated?, :except => :index
before_filter :is_referee?, :only => :index

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @waiting_players = @tournament.players.waiting_players
    @waiting_players.sort! { |a, b| a.user.last_name <=> b.user.last_name }
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
      user.calendar = calendar
      user.picture = picture
    end

    @player.user = user
    @player.tournament = tournament
    @player.team = Team.new if tournament.team_game
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @player = Player.new(params[:player])
    @player.status = :waiting_approval

    if @tournament.team_game
      team_name = params[:team] ? params[:team][:name] : nil
      logger.info('searching for existing team with name: %s' % team_name)
      @team = Team.find_by_tournament_id_and_name(@tournament.id, team_name) || Team.new(params[:team])
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

      send_registration_mails

    else
      # if user is not logged in, we create new user with new calendar and such
      username = generate_username(params[:user][:last_name], params[:user][:first_name])
      passwd = generate_passwd(params[:player][:alias])
      @user = User.new(params[:user])
      logger.info("creating new user: #{@user.first_name} #{@user.last_name} (#{@player.alias}), username #{username}")
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

      @mail_sent = send_registration_mails(username, passwd)
    end
    render :registration_complete
  end

  # rescue ActiveRecord::RecordInvalid => e
    # @player.valid?
    # redirect_to :back
  # end

  def send_registration_mails(username = nil, password = nil)
    logger.info 'sending registration mails'
    begin
      IlmoMailer.referee_message(@player).deliver if @player.tournament.send_registration_announcements_to_referees
      logger.info 'referee info mail sent succesfully'
    rescue Exception => e
      logger.info 'failed to send referee info mail!'
      logger.error "Error: #{e}"
      e.backtrace.each { |line| logger.error line }
    end
    begin
      IlmoMailer.player_message(@player, username, password).deliver
      @player.update_attribute(:registration_email_sent, true)
      logger.info 'registration mail sent succesfully'
      return true
    rescue Exception => e
      logger.error 'failed to send registration mail!'
      logger.error "Error: #{e}"
      e.backtrace.each { |line| logger.error line }
      @player.update_attribute(:registration_email_sent, false)
      return false
    end
  end

  def generate_username(last_name, first_name)
    lname_max = 8
    last_name = last_name.gsub(/\W/, '') # leave only alphanumerals (and underscore)
    last_name = last_name.length > lname_max ? last_name[0..lname_max] : last_name # overtly long usernames are bad
    username = last_name.downcase + first_name.gsub(/\W/, '').downcase[0..0] # last name plus first char of first name
    return User.augment_if_exists(username)
  end

  def generate_passwd(covername) # generates quasi-random, yet memorizable passwd
    covername = covername.gsub(/\W/, '') # leave only alphanumerals (and underscore)
    cover_slice = covername[0..5].downcase

    time_hash = Digest::MD5.hexdigest(Time.now.to_s+covername+rand().to_s)
    hash_slice_ind = rand(time_hash.length-3)
    hash_slice = time_hash[hash_slice_ind..hash_slice_ind+3]

    # stick cover slice randomly inside hash slice
    # cover_slice_ind = rand(hash_slice.length)
    cover_slice + hash_slice
  end

  def reconfirm_registration(player, is_new_user)
    @player = player
    return if @player.registration_email_sent
    password = nil
    if is_new_user
      password = generate_passwd(@player.alias)
      @player.user.password = password
      @player.user.save
    end
    success = send_registration_mails(@player.user.username, password)
    logger.info "#{success ? "registration mails resent successfully" : "resending registration mails failed"}"
    success
  end

end
