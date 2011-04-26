class NoNullsInTournamentStats < ActiveRecord::Migration
  def self.up
    change_column :tournaments, :murdered, :integer, :default => 0, :null => false
    change_column :tournaments, :killed, :integer, :default => 0, :null => false
    change_column :tournaments, :arrested, :integer, :default => 0, :null => false
    change_column :tournaments, :collaterals, :integer, :default => 0, :null => false
    change_column :tournaments, :witnesses, :integer, :default => 0, :null => false
    change_column :tournaments, :eyewitnesses, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
