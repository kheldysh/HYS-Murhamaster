class TargetsController < ApplicationController

  before_filter :is_hunter_or_referee?
  before_filter :is_referee?, :only => :edit

  def show
    @target = Player.find(params[:id])
    @user = @target.user
    @tournament = @target.tournament
    @calendar = @user.calendar
    @referee = is_referee?
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


  def is_hunter_or_referee?
    if current_user.admin
      return true
    end
    @target = Player.find(params[:id])

    @target.tournament.referees.each do |referee|
      if current_user.referees.include? referee
        return true
      end
    end

    current_user.players.each do |player|
      if player.targets.include? @target
        return true
      end
    end
    redirect_to root_path
    return false
  end
end

