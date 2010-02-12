class AddOrganizationToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :organization, :string
  end

  def self.down
    remove_column :teams, :organization
  end
end
