class BooksController < ApplicationController
  before_action :authenticate_user!

  def new
    @book = Book.new
  end

  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    # @book_comment.user_id = @user.id
  end

  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = current_user
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    if @user != current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

#   ログイン中にURLを入力すると他人が投稿した本の編集ページに遷移できないようにする
#   def ensure_correct_user
#       @book = Book.find(params[:id])
#       unless @book.user == current_user
#         redirect_to books_path
#       end
#   end

end
