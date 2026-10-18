class SlaPolicy < ApplicationRecord
  has_many :brands, dependent: :restrict_with_error
  validates :name, presence: true
  validates :first_response_minutes, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 1440 }
end
