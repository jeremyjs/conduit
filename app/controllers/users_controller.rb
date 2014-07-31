class UsersController < ApplicationController
  def index
    @non_enova_users = User.all - User.all.enova_users
    @roles = Role.all
  end
end
