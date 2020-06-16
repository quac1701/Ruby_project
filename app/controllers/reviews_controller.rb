class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_banned_user, except: [:index, :show]
  before_action :find_book, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]
  before_action :check_existing_review, only: [:new, :create]

  def index
    @reviews = Review.all
  end

  def show
    @new_comment = Comment.build_from(@review, current_user.id, "") if current_user
  end

  def new
    @review = Review.new
  end

  def edit
  end

  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to book_path(@book), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to book_path(@book), notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to book_path(@book), notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(:content, :rating, :book_id, :user_id)
    end

    def find_book
      @book = Book.find_by id: params[:book_id]
    end

    def require_permission
      if current_user.id != @review.user.id
        redirect_to(root_path, alert: "Unauthorized Access")
      end
    end

    def check_existing_review
      if Review.find_by(book_id: @book.id, user_id: current_user.id)
        redirect_to(book_path(@book), alert: "Already reviewed this book")
      end
    end

    def check_banned_user
      if current_user.banned?
        redirect_to root_path, alert: "Your account has been banned"
      end
    end
end
