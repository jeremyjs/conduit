class AddWidgetIdToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :widget_id, :integer
  end
end
