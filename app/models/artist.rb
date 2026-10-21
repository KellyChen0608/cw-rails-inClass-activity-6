class Artist < ApplicationRecord
  has_many :tracks, dependent: :nullify
end