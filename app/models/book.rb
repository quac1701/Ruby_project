class Book < ApplicationRecord
  belongs_to :user
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true
  validates :public_year, inclusion: 1800..2100
  validate :has_categories
  mount_uploader :cover, BookCoverUploader
  validates_presence_of :cover
  validates_integrity_of :cover
  validates_processing_of :cover
  scope :search_by_title, ->(keyword) do
    where(status: "accepted").where("title LIKE ?" , "%#{keyword}%")
  end
  scope :search_by_author, ->(keyword) do
    where(status: "accepted").where("author LIKE ?", "%#{keyword}%")
  end
  scope :search_by_public_year, ->(keyword) do
    where(status: "accepted", public_year: keyword)
  end
  scope :recently_reviewed, -> do
    where(status: "accepted").includes(:reviews).order("reviews.created_at desc").uniq
  end
  scope :pending, -> do
    where(status: "pending")
  end
  scope :accepted, -> do
    where(status: "accepted")
  end
  scope :search_by_category, ->(category) do
    where(status: "accepted").includes(:categories).where(categories: {name: category})
  end
  scope :get_by_ids, -> (ids) do
    where(status: "accepted").where(id: ids)
  end

  before_save :refine_book_link

  def self.fuzzy_search keyword
    Book.where("title LIKE ?" , "%#{keyword}%")
      .or(Book.where("author LIKE ?", "%#{keyword}%"))
      .or(Book.where(public_year: keyword))
      .where(status: "accepted")
  end

  def pending?
    self.status == "pending"
  end

  private

  def has_categories
    errors.add(:base, "One of the categories must be checked") unless categories.size > 0
  end

  def add_protocol_to_url link
    link.start_with?("http") ? link : "https://#{link}"
  end

  def refine_book_link
    self.link = add_protocol_to_url(self.link)
  end
end
