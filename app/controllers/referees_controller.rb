class RefereesController < ApplicationController
  before_filter :is_admin?
  
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @referees = @tournament.referees
    @new_judge = Referee.new
  end
    
  def new
    @tournament = Tournament.find(params[:tournament_id])
    @referee = Referee.new
    @users = User.all
  end
    
  def create
    attributes = params[:referee]
    attributes[:tournament_id] = params[:tournament_id]

    @judge = Referee.new(attributes)
    @judge.save
    redirect_to tournament_referees_path
  end
  
  def destroy
    @referee = Referee.find(params[:id])
    @referee.delete
    redirect_to :back
  end
end
