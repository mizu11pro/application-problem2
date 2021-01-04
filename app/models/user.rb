class User < ApplicationRecord
 # Include default devise modules. Others available are:
 # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
 devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

 has_many :books, dependent: :destroy
 has_many :book_comments, dependent: :destroy
 has_many :favorites, dependent: :destroy
 attachment :profile_image

 # フォロー機能
 #1 仮の名前
 #2 class_nameが中間テーブル指定
 #3 foreign_keyで主キー選択

 # フォローしている人のデータ取得
 has_many :of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
 # フォローしている人のデータをrelationship(中間テーブル)を通して相手側(フォローしている人)と紐付け
 #  has_many :followers, through: :of_relationships, source: :follower と紐付け

 # フォローされている人のデータ取得
 has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
 # フォローしている人のデータをrelationship(中間テーブル)を通して相手側(フォロワー)と紐付け
 #  has_many :followings, through: :relationships, source: :followed と紐付け

 #1 フォロー/フォロワーの記述
 #2 紐付けするデータの指定
 #3 スルーはあるリレーションを他のテーブルを通して実現する際に用いる

 # 自分がフォローしている人
 has_many :followers, through: :of_relationships, source: :follower
 # has_many :of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy と紐付け
 # 自分をフォローしている人(相手側)
 has_many :followings, through: :relationships, source: :followed
 # has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy と紐付け

 validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
 validates :introduction, length: {maximum: 50}

 # フォロー機能
  # フォローをする
  def follow(user_id)
      relationships.create(followed_id: user_id)
      # createメソッドはnewとsaveを合わせた挙動
      # 下記と同様の意味
      # relationship = relationships.new(followed_id: user_id)
      # relationship.save
  end

  # フォロー機能を複数持たないように指定し、削除をする
  def unfollow(user_id)
      relationships.find_by(followed_id: user_id).destroy
      # いいねと同じように、ユーザAがユーザBに対して複数個のフォローを作成することはなく、
      # ユーザBをフォローしている場合、relationshipsテーブルには対応するレコードはただ一つです。
      # そのためfind_byによって1レコードを特定し、destroyメソッドで削除しています。
  end

  # フォローしているユーザを確認する
  def following?(user)
      followings.include?(user)
      # 引数に渡したユーザを、フォローしているかどうかを判定します。
      # include?は対象の配列に引数のものが含まれていればtrue、含まれていなければfalseを返します。
      # @user.followingsは「@userがフォローしているユーザ一覧」ですので、
      # ここに含まれていれば、引数に渡したユーザをフォローしている（true）ことになります。
      # このメソッドは、ビューでフォローする/フォローを外すボタンの表示で用いています。
  end

  # 検索機能
  def self.search(search,word)
   # 前方一致
   if search == "forward_match"
    @user = User.where("name LIKE?","#{word}%")
    # 完全一致
   elsif search == "perfect_match"
    @user = User.where(name:"#{word}")

   else
    @user = User.all
   end
  end


end