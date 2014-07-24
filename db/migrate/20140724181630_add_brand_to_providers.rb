class AddBrandToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :brand_id, :string
  end
end
