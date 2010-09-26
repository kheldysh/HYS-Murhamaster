class AssignmentsController < ApplicationController

  before_filter :is_referee?
  
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @assignments = @tournament.assignments
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
    redirect_to :tournament_assignments
  end

  def is_referee?
    @tournament = Tournament.find(params[:tournament_id])
    if current_user.admin
      return true
    end
    @tournament.referees.each do |referee|
      if current_user.referees.include? referee
        return true
      end
    end
    redirect_to root_path
    return false
  end

end
