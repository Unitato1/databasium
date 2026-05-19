class BlogAuthor < ApplicationRecord
  has_one :blog_author_profile, dependent: :destroy
  has_many :blog_posts, dependent: :destroy
  has_many :blog_comments, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
