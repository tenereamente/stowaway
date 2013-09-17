class DropOldStorageTable < ActiveRecord::Migration
  def change
    drop_table :storage_spaces
  end
end
