class AddNameToGraph < ActiveRecord::Migration
  def change
    add_column :graphs, :name, :string
  end
end
