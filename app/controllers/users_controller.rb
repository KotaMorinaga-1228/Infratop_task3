class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def show
    @new_book = Book.new
    @user= User.find(params[:id])
    @books = @user.books
  end

  def index
    @new_book = Book.new
    @user= current_user
    @users = User.page(params[:page])
  end

  def edit
    @user= User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to user_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
