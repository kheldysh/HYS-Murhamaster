class TeamAssignmentsController < ApplicationController

  before_filter :is_referee?

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @assignments = TeamAssignment.find_all_by_tournament_id(@tournament.id) || []
    @new_assignment = TeamAssignment.new
  end

  def new
    @assignment = TeamAssignment.new
  end


  def create
    attributes = params[:team_assignment]
    attributes[:tournament_id] = params[:tournament_id]
    @assignment = TeamAssignment.create(attributes)
    redirect_to :tournament_team_assignments
  end
  
  def destroy
    @assignment = TeamAssignment.find(params[:id])
    @assignment.delete
    redirect_to :back
  end


end
