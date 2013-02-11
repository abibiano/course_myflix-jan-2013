class AddPositionToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :position, :decimal
  end
end
