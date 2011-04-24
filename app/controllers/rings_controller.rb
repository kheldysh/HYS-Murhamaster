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
    @tournament = Tournament.find(params[:tournament_id])
    @ring = Ring.new(params[:ring])
    @ring.tournament = @tournament
    @ring.save!
    redirect_to :tournament_rings
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

end
