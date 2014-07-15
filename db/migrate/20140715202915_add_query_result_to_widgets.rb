class AddQueryResultToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :query_result, :text
    add_column :widgets, :variables, :text

    remove_column :queries, :query_result 
    remove_column :queries, :variables
  end
end
