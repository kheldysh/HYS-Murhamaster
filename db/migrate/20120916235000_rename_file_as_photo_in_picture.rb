class RenameFileAsPhotoInPicture < ActiveRecord::Migration
  def self.up
    remove_attachment :pictures, :file
    add_attachment :pictures, :photo
  end

  def self.down
    remove_attachment :pictures, :photo
    add_attachment :pictures, :file
  end
end
