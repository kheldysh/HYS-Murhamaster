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
    @tournament = Tournament.find(params[:tournament_id])
    @active_players = @tournament.players.find_all { |player| player.active? }
    @ring = Ring.find(params[:id])
    @new_assignment = Assignment.new
  end
  
  def update
    new_params = purge_assignments(params)
    @tournament = Tournament.find(new_params[:tournament_id])
    @ring = Ring.find(new_params[:id])
    # TODO: move this to AssignmentController and assignments wholly under rings
    if new_params[:assignment]
      @new_assignment = Assignment.new(new_params[:assignment])
      @ring.assignments.push(@new_assignment)
      @ring.save
    else
      @ring.update_attributes(new_params[:ring])
    end
    redirect_to :tournament_rings

  end
  
  def destroy
    @ring = Ring.find(params[:id])
    @ring.destroy
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
    false
  end

  # remove killed player from ring
  def self.drop_from_rings(player)
    unless player.tournament.team_game?
      for ring in player.tournament.rings
        # assumes that ring will only contain one target per players
        hunting = ring.assignments.find(:first, :conditions => ["target_id = ?", player])
        hunted = ring.assignments.find(:first, :conditions => ["player_id = ?", player])
        if hunting and hunted
          hunted.player = hunting.player
          hunted.save
          hunting.delete
        end
      end
    end
  end

  def purge_assignments(old_params)
    if old_params[:ring]
      # TODO: move this check to Assignment model and handle it properly
      old_params[:ring][:assignments_attributes].each do |key, assignment|
        if %{"0", ""}.include?(assignment[:player_id]) || %{"0", ""}.include?(assignment[:target_id])
          old_params[:ring][:assignments_attributes].delete(key)
        elsif assignment[:player_id] == assignment[:target_id]
          old_params[:ring][:assignments_attributes].delete(key)
        end
      end
    elsif old_params[:assignment]
      if old_params[:assignment][:player_id] == "0" or old_params[:assignment][:target_id] == "0"
        old_params.delete(:assignment)
      end
    end
    old_params
  end
end
