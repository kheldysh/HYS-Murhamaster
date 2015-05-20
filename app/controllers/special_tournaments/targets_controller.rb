class SpecialTournaments::TargetsController < ApplicationController
  skip_filter :is_authenticated?
  before_filter :is_special_tournament?
  before_filter :tournament_running?

  def index
    @targets = Tournament.find(params[:special_tournament_id]).players.active_players
  end

  def show
    @target = Player.find_by_tournament_id_and_id(params[:special_tournament_id], params[:id])
  end

  def is_special_tournament?
    return true if Tournament.find(params[:special_tournament_id]).special_event?
    redirect_to(root)
  end

  def tournament_running?
    return true if Tournament.find(params[:special_tournament_id]).is_running?
    redirect_to(root)
  end
end

