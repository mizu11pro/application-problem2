class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # 相手側の指定？
  def followers
    user = User.find(params[:user_id])
    @user = user.followings
    # ユーザがフォローしているユーザ一覧
  end

  def followings
    user = User.find(params[:user_id])
    @user = user.followers
    # ユーザがフォローされているユーザ一覧
  end

end