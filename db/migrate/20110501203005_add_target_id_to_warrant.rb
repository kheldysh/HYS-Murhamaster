class AddTargetIdToWarrant < ActiveRecord::Migration
  def self.up
    add_column :warrants, :target_id, :integer
  end

  def self.down
    remove_column :warrants, :target_id
  end
end
