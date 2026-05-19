class BlogCategory < ApplicationRecord
  has_many :blog_posts, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
