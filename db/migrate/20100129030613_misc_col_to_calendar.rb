class MiscColToCalendar < ActiveRecord::Migration
  def self.up
    add_column :calendars, :misc, :text
  end

  def self.down
    remove_column :calendars, :misc
  end
end
