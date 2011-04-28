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
    for player in @tournament.players
      @ring.assignments.build
    end
  end

  def create
    params = purge_empty_assignments(params)

    @tournament = Tournament.find(params[:tournament_id])
    @ring = Ring.new(params[:ring])
    @ring.tournament = @tournament
    @ring.save!
    redirect_to :tournament_rings
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @ring = Ring.find(params[:ring_id])
  end
  
  def update
    params = purge_empty_assignments(params)

    @tournament = Tournament.find(params[:tournament_id])
    @ring = Ring.find(params[:ring_id])
    @ring.update_attributes(params[:ring])

  end
  
  def destroy
    @ring = Ring.find(params[:id])
    @ring.delete
    redirect_to :tournament_rings
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

  # remove killed player from ring
  def self.drop_from_rings(player)
    for ring in player.tournament.rings
      # assumes that ring will only contain one target per players
      hunting = ring.assignments.find(:first, :conditions => ["target_id = ?", player])
      hunted = ring.assignments.find(:first, :conditions => ["player_id = ?", player])
      if hunting and hunted
        hunted.player = hunting.player
        hunted.save!
        hunting.delete
      end
    end
  end

  def purge_empty_assignments(params)
    # purge assignments without players or targets
    # TODO: move this check to Assignment model and handle it properly
    params[:ring][:assignments_attributes].each do |key, ass|
      if ass[:player_id] == "0" or ass[:target_id] == "0"
        logger.info("puring empty assignment: #{ass[:player_id]}->#{ass[:target_id]}")
        params[:ring][:assignments_attributes].delete(key)
      end
    end
    return params
  end
end
