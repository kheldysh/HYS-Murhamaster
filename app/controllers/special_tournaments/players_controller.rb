class SpecialTournaments::PlayersController < ApplicationController
  before_filter :is_referee?, :only => [:index, :show, :update, :destroy, :edit]


  def index
    @tournament = Tournament.find(params[:special_tournament_id])
  end

  def show
    @player = Player.find_by_tournament_id_and_id(params[:special_tournament_id], params[:id])
  end

  def edit
    @player = Player.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  def update
    player = Player.find(params[:id])
    old_alias = player.alias
    # log killings
    if params[:player]
      params[:player][:status] = params[:player][:status].to_sym if params[:player].include?(:status)
      player.update_attributes(params[:player])
      # alias is only modifiable from ilmo listing
      if params[:player][:alias] != old_alias
        redirect_to special_tournament_ilmos_path(player.tournament)
      else
        redirect_to special_tournament_players_path(player.tournament)
      end
    else
      redirect_to special_tournament_players_path(player.tournament)
    end
  end

  def destroy
    player = Player.find(params[:id])
    tournament = player.tournament
    player.destroy
    redirect_to special_tournament_players_path(tournament)
  end

  def is_referee?
    tournament = Tournament.find(params[:special_tournament_id])
    if current_user.is_referee_for?(tournament) && tournament.is_relevant_for_referee?
      logger.info("user #{current_user.username} accessed a referee-restricted page")
      true
    else
      logger.info("user #{current_user.username} tried to access referee-restricted page without permission")
      redirect_to(root_path)
    end
  end
end

