class AddPageToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :page, :integer
  end
end
