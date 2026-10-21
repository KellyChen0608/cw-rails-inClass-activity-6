class Festival < ApplicationRecord
    has_many :stages, dependent: :destroy
    has_many :tickets, dependent: :destroy

    validates :name, presence: true
end
