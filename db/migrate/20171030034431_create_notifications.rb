class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :notified_by, index: true
      t.string :notice_type
      t.string :book_id
      t.string :request_status
      t.integer :review_id
      t.boolean :is_read, default: false

      t.timestamps
    end
    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, column: :notified_by_id
  end
end
