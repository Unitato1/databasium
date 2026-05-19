class BlogPost < ApplicationRecord
  belongs_to :blog_author
  belongs_to :blog_category
  has_many :blog_comments, dependent: :destroy
  has_many :blog_taggings, dependent: :destroy
  has_many :blog_tags, through: :blog_taggings

  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: true
end
