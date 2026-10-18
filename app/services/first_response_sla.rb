# Shared policy entry point: future brand policies can supply their target here.
class FirstResponseSla
  TARGET = 60.minutes

  def initialize(ticket)
    @ticket = ticket
  end

  def deadline
    @ticket.created_at + TARGET
  end

  # A response exactly at the deadline meets the target.
  def breached?(at: Time.current)
    (@ticket.first_response_at || at) > deadline
  end

  def overdue?(at: Time.current)
    @ticket.first_response_at.nil? && breached?(at: at)
  end

  def remaining_seconds(at: Time.current)
    [ deadline - at, 0 ].max
  end
end
