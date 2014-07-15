class RenameQueryTableToTable < ActiveRecord::Migration
  def change
    rename_table :query_tables, :tables
  end
end
