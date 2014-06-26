class CreateQueryTables < ActiveRecord::Migration
  def change
    create_table :query_tables do |t|
      t.integer :query_id

      t.timestamps
    end
  end
end
