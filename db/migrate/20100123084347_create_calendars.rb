class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.integer :user_id      
      t.text :monday
      t.text :tuesday
      t.text :wednesday
      t.text :thursday
      t.text :friday
      t.text :saturday
      t.text :sunday
      
      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
