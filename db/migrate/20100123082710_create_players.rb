class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :alias
      t.string :type
      t.integer :user_id
      t.integer :tournament_id

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
