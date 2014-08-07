class UsersController < ApplicationController
  def index
    @non_enova_users = User.all - User.all.enova_users
    @roles = Role.all
    @ldap_groups = User.get_all_ldap_groups
    @ldap_role_mappings = LdapRoleMapping.all
  end

  def add_user
    @user = User.new({email: params[:email], login: params[:login], password: params[:password], password_confirmation: [:password_confirmation]})
    @user.provider = Provider.find_by(name: params[:provider])
    respond_to do |format|
      if @user.save(validate: false)
        format.json { render json: @user }
        format.js { render json: @user }
      else
        format.json { render json: @user.errors}
        format.js { render json: @user.errors}
      end
    end
  end

  def update_mappings
    params['mappings'].each do |email, roles|
      puts "adding to #{email}"
      @user = User.find_by(email: email)
      @user.roles = []
      UserRoleMapping.where(user_id: @user.id).destroy_all
      roles.each do |role_name|
        unless role_name == 'nil'
          @user.add_role role_name.to_sym
          UserRoleMapping.find_or_create_by(user_id: @user.id, role: role_name)
        end
      end
    end
    respond_to do |format|
      format.json { render json: @user.errors}
      format.js { render json: @user.errors}
    end
  end

  def destroy
    @user = User.find_by(email: params['email'])
    respond_to do |format|
      if @user.destroy!
        format.json { render json: @user.errors}
        format.js { render json: @user.errors}
      else
        format.json { render json: @user.errors}
        format.js { render json: @user.errors}
      end
    end
  end
end
