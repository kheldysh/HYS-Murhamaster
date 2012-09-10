class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :name
      t.string :content_type
      t.binary :data
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
