class ChangeMapping < ActiveRecord::Migration
  def change
    drop_table :addresses
    add_column :storage_spaces, :address, :string
  end
end
