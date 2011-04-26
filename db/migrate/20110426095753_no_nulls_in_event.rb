class NoNullsInEvent < ActiveRecord::Migration
  def self.up
    change_column :events, :murders, :integer, :default => 0, :null => false
    change_column :events, :self_defenses, :integer, :default => 0, :null => false
    change_column :events, :arrests, :integer, :default => 0, :null => false
    change_column :events, :collaterals, :integer, :default => 0, :null => false
    change_column :events, :witnesses, :integer, :default => 0, :null => false
    change_column :events, :eyewitnesses, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
