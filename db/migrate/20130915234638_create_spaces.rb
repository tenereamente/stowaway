class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.integer  "user_id"
      t.integer  "height"
      t.integer  "length"
      t.integer  "width"
      t.string   "units"
      t.text     "notes"
      t.string   "address1"
      t.string   "address2"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "normalized_address"
      t.float    "lat"
      t.float    "lng"
      t.timestamps
    end
  end
end
