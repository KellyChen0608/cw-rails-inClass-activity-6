class Track < ApplicationRecord
  belongs_to :artist
  validates :title, presence: true
end