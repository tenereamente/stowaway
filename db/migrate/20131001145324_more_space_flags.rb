class MoreSpaceFlags < ActiveRecord::Migration
  def change
  	add_attachment :spaces, :photo2
  	add_attachment :spaces, :photo3
  	add_attachment :spaces, :photo4
  	add_attachment :spaces, :photo5
  	add_column :spaces, :climate_controlled, :boolean, :default => false
  	add_column :spaces, :lockable, :boolean, :default => false
  	add_column :spaces, :attended, :boolean, :default => false
  	add_column :spaces, :featured, :boolean, :default => false
  end
end
