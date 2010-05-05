class ChangePlayerTypeToStatus < ActiveRecord::Migration
  def self.up
    rename_column :players, :type, :status
  end

  def self.down
    rename_column :players, :status, :type
  end
end
