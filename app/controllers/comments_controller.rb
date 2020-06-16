class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_banned_user

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)

    if @comment.save
      make_child_comment
      if @comment.parent && @comment.parent.id != @comment.user.id
        a = Notification.create! user: @comment.parent.user, notified_by: @comment.user,
          notice_type: 'REPLY', comment_id: @comment.id, is_read: false
      end
      redirect_to review_path(commentable), notice: "Comment created"
    else
      redirect_to review_path(commentable), notice: "Failed"
    end
  end

  def new

  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end

  def check_banned_user
    if current_user.banned?
      redirect_to root_path, alert: "Your account has been banned"
    end
  end
end
