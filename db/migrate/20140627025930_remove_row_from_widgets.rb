class RemoveRowFromWidgets < ActiveRecord::Migration
  def change
    remove_column :widgets, :row, :integer
  end
end
