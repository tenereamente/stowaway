class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :price
      t.boolean :active
      t.references :space, index: true

      t.timestamps
    end
  end
end
