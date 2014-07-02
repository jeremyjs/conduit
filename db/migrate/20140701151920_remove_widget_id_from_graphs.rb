class RemoveWidgetIdFromGraphs < ActiveRecord::Migration
  def up
    remove_column :graphs, :widget_id
  end
  def down
    add_column :graphs, :widget_id, :integer
  end
end
