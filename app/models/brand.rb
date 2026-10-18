class Brand < ApplicationRecord
  belongs_to :sla_policy, optional: true
  validates :sla_policy, presence: true, if: -> { sla_policy_id.present? }
  has_many :tickets, dependent: :restrict_with_error
  validates :name, presence: true

  def first_response_minutes
    sla_policy&.first_response_minutes || FirstResponseSla::DEFAULT_TARGET_MINUTES
  end
end
