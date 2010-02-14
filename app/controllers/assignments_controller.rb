class AssignmentsController < ApplicationController

  before_filter :is_admin?


  def index
    @tournament = Tournament.find(params[:tournament_id])
    @assignments = Assignment.find(:all, [ "tournament_id = ?", @tournament.id ], :order => "player_id ASC")
    @new_assignment = Assignment.new
  end

  def new
    @assignment = Assignment.new
  end


  def create
    attributes = params[:assignment]
    attributes[:tournament_id] = params[:tournament_id]
    @assignment = Assignment.new(params[:assignment])
    @assignment.save!
    redirect_to :tournament_assignments
  end
  
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.delete
    redirect_to :back
  end


end
