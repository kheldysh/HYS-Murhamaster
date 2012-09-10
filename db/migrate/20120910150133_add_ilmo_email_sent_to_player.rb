class AddIlmoEmailSentToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :registration_email_sent, :boolean
  end

  def self.down
    remove_column :players, :registration_email_sent
  end
end
