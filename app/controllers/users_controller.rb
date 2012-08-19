class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create, :update_password, :update]

  check_authorization
  load_and_authorize_resource

  def index
    @active_users = User.active
    @deactivated_users = User.deactivated
  end

  def new
    authorize! :manage, @user
    @user = User.new
  end

  def create
    authorize! :manage, @user
    @user = User.new(params[:user])
    if @user.save
      redirect_to(@user, :notice => "User successfully created")
    else
      render(:new)
    end
  end

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
    authorize! :manage, @user
    @user = current_user
    if @user.update_attributes(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to edit_user_path(@user), :notice => "Updated!"
    else
      redirect_to edit_user_path(@user), :alert => "Password could not be updated, do they match?"
    end
  end


  def destroy
    find_user
    @user.destroy
    redirect_to users_path, :notice => "User successfully deleted"
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
end
