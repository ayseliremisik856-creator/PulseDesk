class Ticket < ApplicationRecord
  STATUSES = %w[new open solved].freeze
  PRIORITIES = %w[low normal high urgent].freeze
  TRANSITIONS = { "new" => [ "open" ], "open" => [ "solved" ], "solved" => [] }.freeze

  belongs_to :brand
  belongs_to :agent, optional: true
  validates :agent, presence: true, if: -> { agent_id.present? }
  has_many :ticket_responses, dependent: :destroy
  validates :subject, :description, :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :priority, inclusion: { in: PRIORITIES }
  validates :status, inclusion: { in: STATUSES }
  validate :valid_status_transition

  def sla
    FirstResponseSla.new(self)
  end

  def available_statuses
    TRANSITIONS.fetch(status, [])
  end

  private

  def valid_status_transition
    if new_record?
      errors.add(:status, "yeni taleplerde new olmalıdır") unless status == "new"
    elsif will_save_change_to_status? && !TRANSITIONS.fetch(status_in_database, []).include?(status)
      errors.add(:status, "geçişine izin verilmiyor")
    end
  end
end
