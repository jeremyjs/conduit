class CreateSentGraphs < ActiveRecord::Migration
  def change
    create_table :sent_graphs do |t|

      t.timestamps
    end
  end
end
