class AddTournamentToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :tournament_id, :integer
  end

  def self.down
    remove_column :assignments, :tournament_id
  end
end
