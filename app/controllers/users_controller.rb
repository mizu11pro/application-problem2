class UsersController < ApplicationController
  # before_action :ensure_correct_user, only: [:update]
  # ↓
  # before_action :ensure_correct_user, only: [:edit, :update]
#   この場合、ensure_correct_userメソッドのbefore_actionにeditを追加してあげる必要があります。
# before_actionによってeditのアクションを起こす前にensure_correct_userメソッドが働きます。
# ensure_correct_userについて詳しく解説すると
# unlessはifの反対で「もし〜でなければ」という意味になりますので
# unless @user == current_user
# もし@userとcurrent_user(ログインしているユーザー)が一致してなければ、という意味になります。
# 一致していなかった場合、ログインしているuserのshowページにリダイレクトする仕組みになっています
  before_action :authenticate_user!
  # ページ遷移設定
  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books
  end

  def create
    @user = User.new(user_params)
    @book.save
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end