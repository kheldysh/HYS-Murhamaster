class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      # itse sisältö
      t.text :title
      t.text :content
      # metatieto: henkilövahingot
      t.integer :murders
      t.integer :self_defenses
      t.integer :arrests
      t.integer :collaterals
      # metatieto: todistajat
      t.integer :witnesses
      t.integer :eyewitnesses
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
