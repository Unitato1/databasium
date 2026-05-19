class BlogComment < ApplicationRecord
  belongs_to :blog_post
  belongs_to :blog_author

  validates :body, presence: true
end
