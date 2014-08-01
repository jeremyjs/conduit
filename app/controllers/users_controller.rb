class UsersController < ApplicationController
  def index
    @non_enova_users = User.all - User.all.enova_users
    @roles = Role.all
  end

  def add_user
    @user = User.new({email: params[:email], login: params[:login], password: params[:password], password_confirmation: [:password_confirmation]})
    respond_to do |format|
      if @user.save(validate: false)
        format.json { render json: @user.errors}
        format.js { render json: @user.errors}
      else
        format.json { render json: @user.errors}
        format.js { render json: @user.errors}
      end
    end
  end
end
