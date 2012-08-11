class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create, :update_password, :update]
  def edit
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.attempt_set_password(params[:user])
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to edit_user_path(@user), :notice => "Password Updated!"
    else
      redirect_to edit_user_path(@user), :alert => "Password could not be updated, do they match?"
    end
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
end
