class AddTournamentToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :tournament_id, :integer
  end

  def self.down
    remove_column :events, :tournament_id
  end
end
