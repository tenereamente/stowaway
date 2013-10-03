class AdjustWebhooks < ActiveRecord::Migration
  def change
  	rename_column :stripe_events, :event, :data
  	add_column :stripe_events, :type, :string
  	add_column :stripe_events, :livemode, :boolean
  end
end
