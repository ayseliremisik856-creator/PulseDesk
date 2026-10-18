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
  before_validation :snapshot_sla_target, on: :create
  validates :sla_target_minutes, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 1440 }
  validate :preserve_sla_target, on: :update

  def sla
    FirstResponseSla.new(self)
  end

  def available_statuses
    TRANSITIONS.fetch(status, [])
  end

  private

  def snapshot_sla_target
    self.sla_target_minutes = brand&.first_response_minutes || FirstResponseSla::DEFAULT_TARGET_MINUTES
  end

  def preserve_sla_target
    errors.add(:sla_target_minutes, "oluşturulduktan sonra değiştirilemez") if will_save_change_to_sla_target_minutes?
  end

  def valid_status_transition
    if new_record?
      errors.add(:status, "yeni taleplerde new olmalıdır") unless status == "new"
    elsif will_save_change_to_status? && !TRANSITIONS.fetch(status_in_database, []).include?(status)
      errors.add(:status, "geçişine izin verilmiyor")
    end
  end
end
