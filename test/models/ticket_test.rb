require "test_helper"

class TicketTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "Pulse")
    @attributes = { subject: "Ödeme sorusu", description: "Faturamı göremiyorum", customer_name: "Deniz", customer_email: "deniz@example.com", brand: @brand }
  end

  test "ticket starts new with normal priority and a running SLA" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      assert_equal "new", ticket.status
      assert_equal "normal", ticket.priority
      assert_nil ticket.agent
      assert_nil ticket.first_response_at
      assert_equal 60.minutes.from_now, ticket.sla.deadline
    end
  end

  test "required customer and ticket data is validated" do
    ticket = Ticket.new
    assert_not ticket.valid?
    %i[subject description customer_name customer_email brand].each { |field| assert ticket.errors[field].any? }
  end

  test "invalid email and priority are rejected" do
    ticket = Ticket.new(@attributes.merge(customer_email: "invalid", priority: "critical"))
    assert_not ticket.valid?
    assert ticket.errors[:customer_email].any?
    assert ticket.errors[:priority].any?
  end

  test "new records cannot start open or solved" do
    %w[open solved].each do |status|
      assert_not Ticket.new(@attributes.merge(status: status)).valid?
    end
  end

  test "new open solved transitions succeed" do
    ticket = Ticket.create!(@attributes)
    assert ticket.update(status: "open")
    assert ticket.update(status: "solved")
    assert_equal "solved", ticket.reload.status
  end

  test "all backward skipped and unknown transitions fail" do
    ticket = Ticket.create!(@attributes)
    assert_not ticket.update(status: "solved")
    assert_equal "new", ticket.reload.status
    assert_not ticket.update(status: "unknown")
    ticket.reload.update!(status: "open")
    assert_not ticket.update(status: "new")
    ticket.reload.update!(status: "solved")
    %w[new open].each do |status|
      assert_not ticket.update(status: status)
      assert_equal "solved", ticket.reload.status
    end
  end

  test "agent assignment does not change status" do
    ticket = Ticket.create!(@attributes)
    agent = Agent.create!(name: "Ece", email: "ece@example.com")
    ticket.update!(agent: agent)
    assert_equal agent, ticket.reload.agent
    assert_equal "new", ticket.status
  end

  test "unanswered SLA is met before and exactly at 60 minutes and overdue after" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      travel_to ticket.created_at + 59.minutes
      assert_not ticket.sla.overdue?
      travel_to ticket.created_at + 60.minutes
      assert_not ticket.sla.breached?
      assert_equal 0, ticket.sla.remaining_seconds
      travel 1.second
      assert ticket.sla.overdue?
      assert ticket.sla.breached?
    end
  end

  test "staff response exactly on deadline meets SLA permanently" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      ticket.update!(status: "open")
      travel 60.minutes
      ticket.ticket_responses.create!(body: "Merhaba", author_type: "staff")
      assert_equal Time.current, ticket.reload.first_response_at
      travel 2.days
      assert_not ticket.sla.breached?
      assert_not ticket.sla.overdue?
    end
  end

  test "late first response preserves breach after solving" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      ticket.update!(status: "open")
      travel 60.minutes + 1.second
      assert ticket.sla.overdue?
      ticket.ticket_responses.create!(body: "Geciken yanıt", author_type: "staff")
      ticket.reload.update!(status: "solved")
      travel 1.day
      assert ticket.sla.breached?
      assert_not ticket.sla.overdue?
    end
  end

  test "customer and invalid replies do not stop SLA and later staff replies do not reset it" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      ticket.update!(status: "open")
      ticket.ticket_responses.create!(body: "Ek bilgi", author_type: "customer")
      assert_nil ticket.reload.first_response_at
      assert_not ticket.ticket_responses.create(body: "", author_type: "staff").persisted?
      assert_nil ticket.reload.first_response_at
      travel 10.minutes
      ticket.ticket_responses.create!(body: "İlk yanıt", author_type: "staff")
      first = ticket.reload.first_response_at
      travel 70.minutes
      ticket.ticket_responses.create!(body: "İkinci yanıt", author_type: "staff")
      assert_equal first, ticket.reload.first_response_at
      assert_not ticket.sla.breached?
    end
  end

  test "replies require open ticket and recognized author" do
    ticket = Ticket.create!(@attributes)
    assert_not ticket.ticket_responses.create(body: "Yanıt", author_type: "staff").persisted?
    ticket.reload.update!(status: "open")
    assert_not ticket.ticket_responses.create(body: "Yanıt", author_type: "robot").persisted?
    ticket.reload.update!(status: "solved")
    assert_not ticket.ticket_responses.create(body: "Yanıt", author_type: "staff").persisted?
    assert_nil ticket.reload.first_response_at
  end

  test "response and first response timestamp roll back together" do
    ticket = Ticket.create!(@attributes)
    ticket.update!(status: "open")
    assert_no_difference "TicketResponse.count" do
      TicketResponse.transaction do
        ticket.ticket_responses.create!(body: "Yanıt", author_type: "staff")
        raise ActiveRecord::Rollback
      end
    end
    assert_nil ticket.reload.first_response_at
  end
end
