class PlayersController < ApplicationController

  before_filter :own_data?, :except => [:show, :index, :update, :edit]
  before_filter :is_referee?, :only => [:index, :show, :update, :destroy, :edit]


  def index
    @tournament = Tournament.find(params[:tournament_id])
    @active_players = @tournament.players.active_players
    @detectives = @tournament.players.detectives
    @dead_players = @tournament.players.dead_players
  end

  def show
    @player = Player.find(params[:id])
    @user = @player.user
    @calendar = @user.calendar
  end

  def new
  end

  def edit
    @player = Player.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  def create
  end

  def update
    @player = Player.find(params[:id])
    was_active = @player.active?
    logger.info "player was active: %s" % was_active

    # log killings
    if params[:player][:status] == "dead"
      logger.info 'new status: dead'
    end

    @player.update_attributes(params[:player])
    @player.save!

    # if player was active, take care of rings and tournament stats
    if params[:player][:status] == "dead" and was_active
      kill(@player)
    end

    @tournament = Tournament.find(params[:tournament_id])
    redirect_to tournament_players_path(@tournament)
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
  end

  def is_referee? # before_filter
    @tournament = Tournament.find(params[:tournament_id])
    current_user.referees.each do |ref|
      if ref.tournament == @tournament
        return true
      end
    end
    return false
  end

  def kill(player)
    logger.info "Killing player"
    # increase tournament kill count here

    # moving player's targets to new hunters
    RingsController.drop_from_rings(player)
    WarrantsController.drop_from_warrants(player)
  end

end

