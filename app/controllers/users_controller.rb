class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create, :update_password, :update]
  before_filter :authenticate_user!

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
    if current_user.has_role? :admin
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def update_password
    if current_user.has_role? :admin
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    if @user.attempt_set_password(params[:user])
      sign_in(current_user, :bypass => true)
      redirect_to edit_user_path(@user), :notice => "Password Updated!"
    else
      render :edit
    end
  end

  def show
  end

  def update
    if current_user.has_role? :admin
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    unless params[:user][:role_ids].nil?
      unless current_user.has_role? :admin
        params[:user].delete(:role_ids)
      end
    end

    if @user.update_attributes(params[:user])
      sign_in(current_user, :bypass => true)
      redirect_to edit_user_path(@user), :notice => "Updated!"
    else
      redirect_to edit_user_path(@user), :alert => "Password could not be updated, do they match?"
    end
  end


  def destroy
    find_user
    @user.deleted_at = Time.now
    @user.save!
    redirect_to users_path, :notice => "User successfully marked as deactivated"
  end

  def activate
    @user.deleted_at = nil
    @user.save!
    redirect_to users_path, :notice => "User successfully marked as activated"
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
end
