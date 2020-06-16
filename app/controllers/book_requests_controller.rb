class BookRequestsController < ApplicationController
  before_action :check_role, only: :index

  def index
    @pending_books = Book.pending
  end

  private

  def check_role
    redirect_to(root_path, alert: "Unauthorized Access") if current_user.regular_user?
  end
end
