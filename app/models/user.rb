class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  has_many :books, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy

  def regular_user?
    self.role == "Regular User"
  end

  def admin?
    self.role == "Admin" || self.role == "superadmin"
  end

  def super_admin?
    self.role == "superadmin"
  end

  def banned?
    self.is_banned
  end

  def bookmarked? book
    self.bookmarks.exists?(book_id: book.id)
  end

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.nickname = auth.info.name
        user.password = Devise.friendly_token[0,20]
        user.skip_confirmation!
        user.save!
      end
    end
  end
end
