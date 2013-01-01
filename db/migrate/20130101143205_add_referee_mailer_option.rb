class AddRefereeMailerOption < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :send_registration_announcements_to_referees, :boolean
  end

  def self.down
    remove_column :tournaments, :send_registration_announcements_to_referees
  end
end
