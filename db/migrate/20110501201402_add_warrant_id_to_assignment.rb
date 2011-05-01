class AddWarrantIdToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :warrant_id, :integer
  end

  def self.down
  end
end
