class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name
      t.integer :row
      t.integer :column
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
