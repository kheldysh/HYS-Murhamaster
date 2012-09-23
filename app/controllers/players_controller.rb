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
    player = Player.find(params[:id])
    was_active = player.active?
    # log killings
    player.update_attributes(params[:player])
    player.save

    # if player was active, take care of rings and tournament stats
    if params[:player][:status] == "dead" and was_active
      kill(player)
    end

    tournament = player.tournament
    # alias is only modifiable from ilmo listing
    if params[:player][:alias]
      redirect_to tournament_ilmos_path(tournament)
    else
      redirect_to tournament_players_path(tournament)
    end
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