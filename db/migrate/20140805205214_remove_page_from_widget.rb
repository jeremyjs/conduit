class RemovePageFromWidget < ActiveRecord::Migration
  def change
    remove_column :widgets, :page
  end
end
