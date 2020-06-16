class AddCommentIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :comment_id, :integer
  end
end
