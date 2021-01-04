class Book < ApplicationRecord
	belongs_to :user
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
	attachment :profile_image

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
		# いいねした1ユーザのidが存在するかの確認記述
	end

	  # 検索機能
  def self.search(search,word)
   # 前方一致
   if search == "forward_match"
    @book = Book.where("title LIKE?","#{word}%")
    # 完全一致
   elsif search == "perfect_match"
    @book = Book.where(title:"#{word}")

   else
    @book = Book.all
   end
  end

end