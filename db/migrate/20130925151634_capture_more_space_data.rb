class CaptureMoreSpaceData < ActiveRecord::Migration
  def change
    add_column :spaces, :environment, :string
    add_column :spaces, :access, :string
    add_column :spaces, :type, :string
  end
end
