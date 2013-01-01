class DefaultRefereeMailerOptionToTrue < ActiveRecord::Migration
  def self.up
    change_column :tournaments, :send_registration_announcements_to_referees, :boolean, :default => true
  end

  def self.down
    change_column :tournaments, :send_registration_announcements_to_referees, :boolean, :default => nil
  end
end
