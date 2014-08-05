class AddNameToQuery < ActiveRecord::Migration
  def change
    add_column :queries, :name, :string
  end
end
