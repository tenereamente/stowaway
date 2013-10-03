class AddStripeEventsTable < ActiveRecord::Migration
  def change
  	create_table :stripe_events do |t|
      t.string :event_id, unique: true # TODO must be unique
      t.json :event, null: false
      t.boolean :handled, default: false
      t.timestamps
    end
  end
end
