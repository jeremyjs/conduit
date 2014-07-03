class AddPageIdToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :page_id, :integer
  end
end
