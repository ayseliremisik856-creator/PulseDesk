class TicketResponse < ApplicationRecord
  belongs_to :ticket
  validates :body, presence: true
  validates :author_type, inclusion: { in: %w[staff customer] }
  validate :ticket_is_open
  after_create :record_first_response

  private

  def ticket_is_open
    errors.add(:ticket, "yanıt eklemek için açık olmalıdır") if ticket && ticket.status != "open"
  end

  def record_first_response
    return unless author_type == "staff"

    # Conditional SQL update preserves the first timestamp across concurrent replies.
    Ticket.where(id: ticket_id, first_response_at: nil).update_all(first_response_at: created_at)
    ticket.reload
  end
end
