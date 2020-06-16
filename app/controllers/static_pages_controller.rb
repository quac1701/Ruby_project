class StaticPagesController < ApplicationController
  def home
    @recently_reviewed_books =
      Kaminari.paginate_array(Book.recently_reviewed)
        .page(params[:page]).per(8)
  end
end
