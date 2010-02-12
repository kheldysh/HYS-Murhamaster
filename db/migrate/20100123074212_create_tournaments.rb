class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :title
      t.date :start_date
      t.date :finish_date

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
