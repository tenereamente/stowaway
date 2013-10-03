class CreateStripeEvents < ActiveRecord::Migration
  def change
    create_table :stripe_events do |t|

      t.timestamps
    end
  end
end
