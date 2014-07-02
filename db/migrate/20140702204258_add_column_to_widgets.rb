class AddColumnToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :column, :integer
  end
end
