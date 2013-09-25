class AddPhotoTo < ActiveRecord::Migration
  def self.up
  	add_attachment :spaces, :photo
  end

  def self.down
  	remove_attachment :spaces, :photo
  end
end
