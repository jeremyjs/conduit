class CreateUserRoleMappings < ActiveRecord::Migration
  def change
    create_table :user_role_mappings do |t|
      t.integer :user_id
      t.string :role

      t.timestamps
    end
  end
end
