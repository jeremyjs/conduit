class AddProviderToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider_id, :integer
  end
end
