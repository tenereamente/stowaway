class CreateStorageSpaces < ActiveRecord::Migration
  def change
    create_table :storage_spaces do |t|
      t.references :user, index: true
      t.integer :height
      t.integer :length
      t.integer :width
      t.text :notes

      t.timestamps
    end
  end
end
