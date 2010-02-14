class AddRefereeToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :referee_id, :integer
  end

  def self.down
    remove_column :players, :referee_id
  end
end
