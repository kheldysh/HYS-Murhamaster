class SpecialTournaments::TargetsController < ApplicationController
  skip_before_filter :is_authenticated?
  before_filter :is_special_tournament?

  def index
    @targets = Tournament.find(params[:special_tournament_id]).players
  end

  def show
    @target = Player.find_by_tournament_id_and_id(params[:special_tournament_id], params[:id])
  end

  def is_special_tournament?
    return true if Tournament.find(params[:special_tournament_id]).special_event?
    render root
  end
end

