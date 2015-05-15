class AddIsSpecialEventToTournaments < ActiveRecord::Migration
  def self.up
    add_column(:tournaments, :special_event, :boolean, null: false, default: false)
  end

  def self.down
    remove_column(:tournaments, :special_event)
  end
end
