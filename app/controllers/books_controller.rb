class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy, ]
  def create
    @new_book = Book.new(book_params)
    @new_book.user_id = current_user.id
    if @new_book.save
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@new_book.id)
    else
      @books = Book.page(params[:page])
      @user = current_user
      render :index
    end
  end
  def index
    @new_book = Book.new
    @books = Book.page(params[:page])
    @user = current_user
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:notice] = "Book was successfully destroyed."
    redirect_to books_path
  end
  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to book_path(@book.id)
    else
      render :edit
    end

  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def is_matching_login_user
     book = Book.find(params[:id])
     user =User.find(book.user_id)
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end
