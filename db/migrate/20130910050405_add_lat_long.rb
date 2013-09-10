class AddLatLong < ActiveRecord::Migration
  def change
  	add_column :storage_spaces, :lat, :float
  	add_column :storage_spaces, :lng, :float
  end
end
