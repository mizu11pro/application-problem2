class RanksController < ApplicationController
  def index
    @rankbook = Book.joins(:favorites).group(:book_id).order('count(book_id) desc').limit(5)
  end
end
