class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # followerもfollowedも存在しないmodel
  # フォローする人もされる人もuserモデルなので
  # class_nameをつけることで関連先のモデルを参照する際の名前を変更できる
  # Userを「followerとfollowedに分ける」ことをclass_nameが担当
end
