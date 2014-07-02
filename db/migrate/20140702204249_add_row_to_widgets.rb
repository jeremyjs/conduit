class AddRowToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :row, :integer
  end
end
