class CreateIssuedGraphs < ActiveRecord::Migration
  def change
    create_table :issued_graphs do |t|

      t.timestamps
    end
  end
end
