class LdapController < ApplicationController
  def index
    @groups = User.get_all_ldap_groups
    respond_to do |format|
      format.json { render json: @groups.to_json }
    end
  end
end
