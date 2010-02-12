class AddApplicationDeadlineToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :app_deadline, :datetime
  end

  def self.down
    remove_column :tournaments, :app_deadline
  end
end
