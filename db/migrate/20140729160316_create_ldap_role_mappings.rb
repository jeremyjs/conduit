class CreateLdapRoleMappings < ActiveRecord::Migration
  def change
    create_table :ldap_role_mappings do |t|
      t.string :ldap_group
      t.string :role

      t.timestamps
    end
  end
end
