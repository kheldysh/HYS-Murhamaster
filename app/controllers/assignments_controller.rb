class AssignmentsController < ApplicationController

  before_filter :is_referee?
  
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @assignments = @tournament.assignments
    @new_assignment = Assignment.new
  end

  def create
    # attributes = params[:assignment]
    # attributes[:tournament_id] = params[:tournament_id]
    @assignment = Assignment.new(params[:assignment])
    @assignment.save
    redirect_to tournament_rings_path
  end
  
  def destroy
    @tournament = Tournament.find(params[:tournament_id])
    @assignment = Assignment.find(params[:id])
    @ring = @assignment.ring
    @assignment.delete
    redirect_to :tournament_rings
  end
end
