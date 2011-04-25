class AddDatetimeToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :time, :datetime
  end

  def self.down
    remove_column :events, :time
  end
end
