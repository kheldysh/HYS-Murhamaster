class TeamsController < ApplicationController

  before_filter :is_referee?

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @teams = @tournament.teams
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    tournament = Tournament.find(params[:tournament_id])
    @team = Team.new
    @team.tournament = tournament if tournament
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(params[:team])
    @team.tournament = Tournament.find(params[:tournament_id])
    @team.save
    flash[:notice] = 'Team was successfully created.'
    redirect_to(tournament_team_path(@team.tournament, @team))
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attributes(params[:team])
    flash[:notice] = 'Team was successfully updated.'
    redirect_to(@team)
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to(teams_url)
  end
end
