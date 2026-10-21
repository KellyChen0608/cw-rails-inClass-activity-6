class Festival < ApplicationRecord
    has_many :stages, dependent: :destroy
    has_many :tickets

    validates :name, presence: true
end