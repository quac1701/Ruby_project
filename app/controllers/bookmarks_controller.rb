class BookmarksController < ApplicationController
  def index
    book_ids = current_user.bookmarks.pluck(:book_id)
    @books = Book.get_by_ids(book_ids)
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.save
      redirect_back(fallback_location: root_path, notice: "Bookmarked")
    else
      redirect_back(fallback_location: root_path, alert: "Failed")
    end
  end

  def destroy
    bookmark = Bookmark.find_by(id: params[:id])
    bookmark.destroy
    redirect_back(fallback_location: root_path, notice: "Unbookmarked")
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :book_id)
  end
end
