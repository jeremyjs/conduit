class AddVariablesToQuery < ActiveRecord::Migration
  def change
    add_column :queries, :variables, :text
  end
end
