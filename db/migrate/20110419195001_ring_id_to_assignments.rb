class RingIdToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :ring_id, :integer
  end

  def self.down
  end
end
