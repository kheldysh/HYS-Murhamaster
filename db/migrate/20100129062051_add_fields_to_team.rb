class AddFieldsToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :name, :string
    add_column :teams, :tournament_id, :integer
  end

  def self.down
    remove_column :teams, :name
    remove_column :teams, :tournament_id    
  end
end
