class AddLastExecutedToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :last_executed, :datetime
  end
end
