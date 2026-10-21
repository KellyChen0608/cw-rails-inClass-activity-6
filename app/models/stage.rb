class Stage < ApplicationRecord
    belongs_to :festival
    validates :name, presence: true
    validates :capacity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end