class RingsController < ApplicationController

  before_filter :is_referee?
  
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @rings = @tournament.rings
    @new_ring = Ring.new
  end

  def new
    @ring = Ring.new
    @tournament = Tournament.find(params[:tournament_id])
    @active_players = @tournament.players.find_all { |player| player.active? }
    @active_players.each do
      @ring.assignments.build # why this has to be done for each player?
    end
  end

  def create
    new_params = purge_assignments(params)

    @tournament = Tournament.find(new_params[:tournament_id])
    @ring = Ring.new(new_params[:ring])
    @ring.tournament = @tournament
    @ring.save
    redirect_to :tournament_rings
  end

  def edit
    @ring = Ring.find(params[:id])
    @active_players = @ring.tournament.players.select(&:active?)
    @new_assignment = Assignment.new
  end
  
  def update
    new_params = purge_assignments(params)
    logger.info("params after purging: #{new_params}")
    ring = Ring.find(new_params[:id])
    # TODO: move this to AssignmentController and assignments wholly under rings
    if new_params[:ring][:assignment]
      new_assignment = Assignment.new(new_params[:ring][:assignment])
      new_assignment.ring = ring
      new_assignment.save
    else
      ring.update_attributes(new_params[:ring])
    end
    redirect_to :tournament_rings

  end
  
  def destroy
    ring = Ring.find(params[:id])
    ring.destroy
    redirect_to :tournament_rings
  end

  # remove killed player from ring
  def self.drop_from_rings(player)
    player.tournament.rings.each do |ring|
      # when ring only contains one target per player
      hunters_assignment = ring.assignments.find_by_target_id(player)
      own_assignment = ring.assignments.find_by_player_id(player)
      if hunters_assignment && own_assignment
        hunters_assignment.target = own_assignment.target
        hunters_assignment.save
        own_assignment.delete
      end
      # unilateral cases where either no hunter or no target
      hunters_assignments = ring.assignments.find_all_by_target_id(player)
      own_assignments = ring.assignments.find_all_by_player_id(player)
      if hunters_assignments.present?
        hunters_assignments.each(&:delete)
      elsif own_assignments.present?
        own_assignments.each(&:delete)
      end
    end
  end

  def purge_assignments(old_params)
    # remove empty and self-targeting assignments
    if old_params[:ring]
      if old_params[:ring][:assignments_attributes]
        logger.info('purging assignments_attributes')
        # TODO: move this check to Assignment model and handle it properly
        old_params[:ring][:assignments_attributes].each do |key, assignment|
          if %{'0', ''}.include?(assignment[:player_id]) || %{'0', ''}.include?(assignment[:target_id])
            old_params[:ring][:assignments_attributes].delete(key)
          elsif assignment[:player_id] == assignment[:target_id]
            old_params[:ring][:assignments_attributes].delete(key)
          end
        end
      elsif old_params[:ring][:assignment]
        logger.info('purging single assignment')
        if old_params[:ring][:assignment][:player_id] == '0' || old_params[:ring][:target_id] == '0'
          old_params.delete(:assignment)
        end
      end
    end
    old_params
  end
end
