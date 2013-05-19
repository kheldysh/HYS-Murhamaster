class PlayersController < ApplicationController

  before_filter :own_data?, :except => [:show, :index, :update, :destroy, :edit]
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
    player = Player.find(params[:id])
    was_active = player.active?
    # log killings
    player.update_attributes(params[:player])
    player.save
    if params[:player]

      # if player was active, take care of rings and tournament stats
      kill(player) if params[:player][:status] == "dead" && was_active

      tournament = player.tournament
      # alias is only modifiable from ilmo listing
      if params[:player][:alias]
        redirect_to tournament_ilmos_path(tournament)
      end
    end
    redirect_to tournament_players_path(tournament)
  end

  def destroy
    player = Player.find(params[:id])
    tournament = player.tournament
    player.destroy
    redirect_to tournament_players_path(tournament)
  end

  def is_referee? # before_filter
    @tournament = Tournament.find(params[:tournament_id])
    current_user.referees.each do |ref|
      if ref.tournament == @tournament
        return true
      end
    end
    redirect_to root_path
  end

  private

  def kill(player)
    logger.info "Killing player"
    # moving player's targets to new hunters
    RingsController.drop_from_rings(player)
    WarrantsController.drop_from_warrants(player)
  end

end