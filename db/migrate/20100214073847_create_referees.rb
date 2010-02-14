class CreateReferees < ActiveRecord::Migration
  def self.up
    create_table :referees do |t|
      
      t.integer :judge_id
      t.integer :tournament_id

      t.timestamps
    end
  end

  def self.down
    drop_table :referees
  end
end
