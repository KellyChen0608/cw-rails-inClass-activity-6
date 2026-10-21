class Attendees < ApplicationRecord
    has many :tickets, dependent: :restrict_with_error
    validates :name, presence :true
    validates :email, presence :true
end