class CreateRings < ActiveRecord::Migration
  def self.up
    create_table :rings do |t|
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rings
  end
end
