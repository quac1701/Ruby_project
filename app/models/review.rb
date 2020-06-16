class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  acts_as_commentable

  validates :content, presence: true,
    length: {minimum: 6, maximum: 1000}
  validates :rating, presence: true
  validate :rating_between_1_and_5

  private

  def rating_between_1_and_5
    errors.add(:base, "Please choose your rating") unless (1..5).include?(rating)
  end
end
