class AddPrice < ActiveRecord::Migration
  def change
  	drop_table :listings
  	add_column :spaces, :monthly_price, :integer
  end
end
