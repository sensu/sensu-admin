class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create ]
  def edit
  end

  private
  def find_user
    @user = User.find(params[:id])
  end 
end
