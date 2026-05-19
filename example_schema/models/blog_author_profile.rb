class BlogAuthorProfile < ApplicationRecord
  belongs_to :blog_author

  validates :location, presence: true
end
