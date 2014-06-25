class CreateConvertedGraphs < ActiveRecord::Migration
  def change
    create_table :converted_graphs do |t|

      t.timestamps
    end
  end
end
