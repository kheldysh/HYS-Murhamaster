class AddStatsToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :murdered, :integer
    add_column :tournaments, :killed, :integer
    add_column :tournaments, :arrested, :integer
    add_column :tournaments, :collaterals, :integer
    add_column :tournaments, :witnesses, :integer
    add_column :tournaments, :eyewitnesses, :integer
    
  end

  def self.down
    remove_column :tournaments, :murdered
    remove_column :tournaments, :killed
    remove_column :tournaments, :arrested
    remove_column :tournaments, :collaterals
    remove_column :tournaments, :witnesses
    remove_column :tournaments, :eyewitnesses
  end
end
