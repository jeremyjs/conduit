class CreateImportedGraphs < ActiveRecord::Migration
  def change
    create_table :imported_graphs do |t|

      t.timestamps
    end
  end
end
