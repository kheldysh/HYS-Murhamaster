class WarrantsController < ApplicationController
  before_filter :is_referee?
  
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @warrants = @tournament.warrants
    @new_warrant = Warrant.new
  end

  def new
    @warrant = Warrant.new
    @tournament = Tournament.find(params[:tournament_id])
    @active_players = @tournament.players.find_all{ |player| player.active? }
    @detectives = @tournament.players.find_all{ |player| player.detective? }
  end

  def create
    new_params = purge_assignments(params)

    @tournament = Tournament.find(new_params[:tournament_id])
    @warrant = Warrant.new(new_params[:warrant])
    @warrant.tournament = @tournament
    @warrant.save!
    redirect_to :tournament_warrants
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @active_players = @tournament.players.find_all{ |player| player.active? }
    @warrant = Warrant.find(params[:id])
    @new_assignment = Assignment.new
  end
  
  def update
    new_params = purge_assignments(params)
    @tournament = Tournament.find(new_params[:tournament_id])
    @warrant = Warrant.find(new_params[:id])
    # TODO: move this to AssignmentController and assignments wholly under warrants
    if new_params[:assignment]
      @new_assignment = Assignment.new(new_params[:assignment])
      @warrant.assignments.push(@new_assignment)
      @warrant.save!
    else
      @warrant.update_attributes(new_params[:warrant])
    end
    redirect_to :tournament_warrants

  end
  
  def destroy
    @warrant = Warrant.find(params[:id])
    @warrant.delete
    redirect_to :tournament_warrants
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
