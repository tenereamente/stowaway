class DefaultPrice < ActiveRecord::Migration
  def change
  	change_column :spaces, :monthly_price, :integer, :default => 50
  	Space.update_all({ :monthly_price => 50 })
  end
end
