class AddTeamgameToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :team_game, :boolean, :default => false
  end

  def self.down
    remove_column :tournaments, :team_game
  end
end
