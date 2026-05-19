class BlogTag < ApplicationRecord
  has_many :blog_taggings, dependent: :destroy
  has_many :blog_posts, through: :blog_taggings

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
