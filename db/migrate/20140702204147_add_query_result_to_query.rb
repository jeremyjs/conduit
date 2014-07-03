class AddQueryResultToQuery < ActiveRecord::Migration
  def change
    add_column :queries, :query_result, :text
  end
end
