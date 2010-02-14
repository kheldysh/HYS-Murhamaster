class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.column :player_id, :integer
      t.column :target_id, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
