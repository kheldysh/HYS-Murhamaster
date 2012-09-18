class TeamAssignmentsController < ApplicationController

  before_filter :is_referee?

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @assignments = TeamAssignment.find(:all, [ "tournament_id = ?", @tournament.id ], :order => "team_id ASC")
    @new_assignment = TeamAssignment.new
  end

  def new
    @assignment = TeamAssignment.new
  end


  def create
    attributes = params[:team_assignment]
    attributes[:tournament_id] = params[:tournament_id]
    @assignment = TeamAssignment.new(attributes)

    if @assignment.save
      @assignment.team.players.each do |player|
        @assignment.target.players.each do |target_player|
          player.targets << target_player
        end
        player.save
      end
    end

    redirect_to :tournament_team_assignments
  end
  
  def destroy
    @assignment = TeamAssignment.find(params[:id])
    @assignment.delete
    redirect_to :back
  end


end
