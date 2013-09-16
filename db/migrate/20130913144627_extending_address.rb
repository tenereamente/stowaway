class ExtendingAddress < ActiveRecord::Migration
  def change
    add_column :storage_spaces, :address1, :string
    add_column :storage_spaces, :address2, :string
    add_column :storage_spaces, :city, :string
    add_column :storage_spaces, :state, :string
    add_column :storage_spaces, :zip, :string
    add_column :storage_spaces, :country, :string
  end
end
