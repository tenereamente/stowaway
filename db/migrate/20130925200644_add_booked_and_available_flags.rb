class AddBookedAndAvailableFlags < ActiveRecord::Migration
  def change
  	add_column :spaces, :complete, :boolean, :default => false
  	add_column :spaces, :available, :boolean, :default => false
  end
end
