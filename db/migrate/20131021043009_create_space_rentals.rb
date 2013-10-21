class CreateSpaceRentals < ActiveRecord::Migration
  def change
    create_table :space_rentals do |t|
      t.integer :user_id
      t.integer :space_id
      t.timestamps
    end
  end
end
