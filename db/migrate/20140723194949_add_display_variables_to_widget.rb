class AddDisplayVariablesToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :display_variables, :text
  end
end
