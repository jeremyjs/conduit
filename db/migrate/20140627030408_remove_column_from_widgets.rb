class RemoveColumnFromWidgets < ActiveRecord::Migration
  def change
    remove_column :widgets, :column, :integer
  end
end
