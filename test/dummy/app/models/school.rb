class School < ApplicationRecord
  has_many :students
  belongs_to :location
end
