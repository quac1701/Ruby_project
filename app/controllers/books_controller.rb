class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_banned_user, except: [:index, :show]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :accept_request, :reject_request]
  before_action :get_categories, only: [:new, :create, :edit, :update]
  before_action :require_permission, only: [:edit, :update, :destroy]

  def index
    @books = Book.accepted
  end

  def show
    @reviews = @book.reviews
    @bookmark = @book.bookmarks.find_by(user_id: current_user.id) if current_user
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.html do
          if current_user.regular_user?
            notice = "Book request was successfully created. Please wait for an admin to process it. "
          else
            notice = "Book was successfully created."
          end
          redirect_to @book, notice: notice
        end
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept_request
    if @book.update(book_params)
      Notification.create user: @book.user, notified_by: current_user,
        notice_type: 'BOOK_REQUEST', book: @book, request_status: 'ACCEPTED',
        is_read: false
      redirect_to(book_requests_path, notice: "Book request accepted")
    else
      redirect_to(book_requests_path, alert: "Failed")
    end
  end

  def reject_request
    Notification.create user: @book.user, notified_by: current_user,
      notice_type: 'BOOK_REQUEST', book: @book, request_status: 'REJECTED',
      is_read: false
    if @book.update(book_params)
      redirect_to(book_requests_path, notice: "Book request rejected")
    else
      redirect_to(book_requests_path, alert: "Failed")
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_categories
      @categories = Category.all
    end

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :public_year, :synopsis, :link, :user_id, :status,
        :cover, :cover_cache, :remove_cover, category_ids: [])
    end

    def require_permission
      if current_user.regular_user? && current_user.id != @book.user.id
        redirect_to(root_path, alert: "Unauthorized access")
      end
    end

    def check_banned_user
      if current_user.banned?
        redirect_to root_path, alert: "Your account has been banned"
      end
    end
end
