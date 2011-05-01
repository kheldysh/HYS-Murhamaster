class CreateWarrants < ActiveRecord::Migration
  def self.up
    create_table :warrants do |t|
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :warrants
  end
end
