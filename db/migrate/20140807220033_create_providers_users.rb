class CreateProvidersUsers < ActiveRecord::Migration
  def change
    create_table :providers_users do |t|
      t.integer :user_id
      t.integer :provider_id
    end
  end
end
