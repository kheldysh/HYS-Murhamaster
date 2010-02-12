class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :phone
      t.string :address
      t.string :eyes
      t.string :glasses
      t.integer :height
      t.string :hair
      t.string :other_notes

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
