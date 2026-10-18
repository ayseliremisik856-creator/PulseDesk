class Brand < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error
  validates :name, presence: true
end
