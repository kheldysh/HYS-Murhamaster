class TargetsController < ApplicationController

  before_filter :is_hunter_or_referee?, :except => [:edit, :update]
  before_filter :is_target_tournament_referee?, :only => [:edit, :update]

  def show
    @target = Player.find(params[:id])
    @user = @target.user
    @tournament = @target.tournament
    @calendar = @user.calendar

    @referee = false
    current_user.referees.each do |referee|
      if referee.tournament == @tournament
        @referee = true
      end
    end

    if not @referee
      @current_player = current_user.players.find(:first, :conditions => [ "tournament_id = ?", @tournament ])
    end

  end

  def edit
    @target = Player.find(params[:id])
    @user = @target.user
    @tournament = @target.tournament
    @calendar = @user.calendar
  end


  def update
    @tournament = Tournament.find(params[:tournament_id])
    @target = Player.find(params[:id])
    @user = @target.user
    @user.update_attributes(params[:user])
    @calendar = @user.calendar
    @calendar.update_attributes(params[:calendar])

    # not really DRY
    if params[:player]
      if params[:player][:uploaded_picture]
        @picture = Picture.new(params[:player])
        @picture.user = @user
        @user.picture = @picture
        @picture.save!
        @user.save!
      end
    end

    redirect_to tournament_target_path(@tournament, @target)

  end

  def is_target_tournament_referee?
    tournament = Tournament.find(params[:tournament_id])
    current_user.referees.each do |referee|
      if referee.tournament == tournament
        logger.info "current user is not referee for this tournament"
        return true
      end
    end
    redirect_to root_path
    return false
  end

  def is_hunter_or_referee?
    # check admin status
    if current_user.admin
      logger.info "current_user is admin"
      return true
    end

    # check referee status
    if is_target_tournament_referee?
      return true
    end

    # check hunter status
    target = Player.find(params[:id])
    current_user.players.each do |player|
      logger.info "checking current_user's targets, player.id: #{player.id}"
      logger.info player.targets.inspect
      if player.targets.include? target
        logger.info "current_user has this target"
        return true
      end
    end
    logger.info "current_user not hunter nor referee/admin, redirecting"
    redirect_to root_path
    return false
  end
end

