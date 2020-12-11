class Book < ApplicationRecord
	belongs_to :user
	has_many :book_comments, dependent: :destroy
	attachment :profile_image

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
