class Notification < ApplicationRecord
  belongs_to :notified_by, class_name: 'User'
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :review, optional: true
  belongs_to :comment, optional: true
end
