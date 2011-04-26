class SelfDefensesToKillsInEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :self_defenses, :kills
  end

  def self.down
  end
end
