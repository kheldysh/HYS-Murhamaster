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
    @users = {}
    # pick unique players based on last login
    all_users = User.all
    all_users.map(&:email).uniq.each do |email|
      @users[email] = User.all.select { |u| u.email == email }.select(&:last_login).max { |a, b| a.last_login <=> b.last_login }
    end

    @users = @users.values.compact.sort { |a, b| a.last_name <=> b.last_name }
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
