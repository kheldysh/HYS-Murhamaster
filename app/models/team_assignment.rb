class TeamAssignment < ActiveRecord::Base

  belongs_to :team
  belongs_to :tournament
  
  belongs_to :target, :class_name => "Team", :foreign_key => "target_id"

  before_create :assign_targets_to_players

  def assign_targets_to_players
    team.players.each do |player|
      target.players.each do |target_player|
        player.targets << target_player
      end
      player.save
    end
  end

end
