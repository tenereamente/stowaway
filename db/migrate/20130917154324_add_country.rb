class AddCountry < ActiveRecord::Migration
  def change
    add_column :spaces, :country, :string
  end
end
