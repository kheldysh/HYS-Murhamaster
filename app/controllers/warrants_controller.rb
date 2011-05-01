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
    for detective in @detectives
      @warrant.assignments.build(attributes = {:player => detective})
    end
  end

  def create
    new_params = purge_assignments(params)
    # if no assignments, don't create warrant
    unless params[:warrant][:assignments_attributes].empty?
      @target = Player.find(params[:warrant][:assignments_attributes]["0"][:target_id])
      @tournament = Tournament.find(new_params[:tournament_id])
      @warrant = Warrant.new(new_params[:warrant])
      @warrant.target = @target
      @warrant.tournament = @tournament
      @warrant.save!
    end
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

  def purge_assignments(old_params)
    logger.info("Purging parameters from faulty assignments")
    if old_params[:warrant]
      logger.info("Found multiple assignments")
      # TODO: move this check to Assignment model and handle it properly
      old_params[:warrant][:assignments_attributes].each do |key, ass|
        # purge assignments without players or targets
        if ["0", ""].include? ass[:player_id]  or ["0", ""].include? ass[:target_id]
          logger.info("purging empty assignment: #{ass[:player_id]}->#{ass[:target_id]}")
          old_params[:warrant][:assignments_attributes].delete(key)
        # purge assignments to own self
        elsif ass[:player_id] == ass[:target_id]
          logger.info("purging self-pointing assignment: #{ass[:player_id]}->#{ass[:target_id]}")
          old_params[:warrant][:assignments_attributes].delete(key)
        end
      end
    elsif old_params[:assignment]
      if old_params[:assignment][:player_id] == "0" or old_params[:assignment][:target_id] == "0"
        logger.info("purging empty old_params[:assignment]ignment: #{old_params[:assignment][:player_id]}->#{old_params[:assignment][:target_id]}")
        old_params.delete(:assignment)
      end
    end
    return old_params
  end

end
