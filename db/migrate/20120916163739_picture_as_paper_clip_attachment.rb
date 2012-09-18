class PictureAsPaperClipAttachment < ActiveRecord::Migration
  def self.up
    remove_column :pictures, :name
    remove_column :pictures, :content_type
    remove_column :pictures, :data

    add_attachment :pictures, :file
  end

  def self.down
    remove_attachment :pictures, :file

    add_column :pictures, :name
    add_column :pictures, :content_type
    add_column :pictures, :data
  end
end
