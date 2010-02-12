class RemoveCalendarIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :calendar_id
  end

  def self.down
    add_column :users, :calendar_id, :integer
  end
end
