class CreateTeamAssignments < ActiveRecord::Migration
  def self.up
    create_table :team_assignments do |t|
      t.integer :team_id
      t.integer :target_id
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :team_assignments
  end
end
