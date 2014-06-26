class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.integer :query_id

      t.timestamps
    end
  end
end
