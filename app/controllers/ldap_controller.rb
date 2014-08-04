class LdapController < ApplicationController
  def index
    @groups = User.get_all_ldap_groups
    respond_to do |format|
      format.json { render json: @groups.to_json }
    end
  end

  def create
    @ldap_role_mapping = LdapRoleMapping.new(ldap_group: params['ldap_group'], role: params['role'])
    respond_to do |format|
      if @ldap_role_mapping.save
        format.json { render json: @ldap_role_mapping.errors}
        format.js { render json: @ldap_role_mapping.errors}
      else
        format.json { render json: @ldap_role_mapping.errors}
        format.js { render json: @ldap_role_mapping.errors}
      end
    end
  end

  def destroy
    @ldap_role_mapping = LdapRoleMapping.find(params['mapping_id'])
    respond_to do |format|
      if @ldap_role_mapping.destroy!
        format.json { render json: @ldap_role_mapping.errors}
        format.js { render json: @ldap_role_mapping.errors}
      else
        format.json { render json: @ldap_role_mapping.errors}
        format.js { render json: @ldap_role_mapping.errors}
      end
    end
  end
end
