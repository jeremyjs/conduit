class AddQueryIdToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :query_id, :integer
  end
end
