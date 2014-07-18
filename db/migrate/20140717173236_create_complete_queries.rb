class CreateCompleteQueries < ActiveRecord::Migration
  def change
    create_table :complete_queries do |t|
      t.integer :query_id
      t.text :variables
      t.text :query_result
      t.datetime :last_executed

      t.timestamps
    end
  end
end
