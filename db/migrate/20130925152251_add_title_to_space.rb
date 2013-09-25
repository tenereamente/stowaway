class AddTitleToSpace < ActiveRecord::Migration
  def change
  	add_column :spaces, :title, :string
  end
end
