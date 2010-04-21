class AddStudyDetailsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :university, :string
    add_column :users, :faculty, :string
    add_column :users, :department, :string
  end

  def self.down
    remove_column :users, :university
    remove_column :users, :faculty
    remove_column :users, :department
    
  end
end
