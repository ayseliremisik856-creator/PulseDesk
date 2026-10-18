require "test_helper"

class SlaPolicyTest < ActiveSupport::TestCase
  setup do
    @policy = SlaPolicy.create!(name: "Ortak", first_response_minutes: 30)
    @a = Brand.create!(name: "A", sla_policy: @policy)
    @b = Brand.create!(name: "B", sla_policy: @policy)
  end

  def ticket_for(brand)
    Ticket.create!(brand: brand, subject: "SLA", description: "Kontrol", customer_name: "Test", customer_email: "test@example.com")
  end

  test "two brands share one policy and new tickets take the same snapshot" do
    [@a, @b].each do |brand|
      ticket = ticket_for(brand)
      assert_equal 30, ticket.sla_target_minutes
      assert_equal ticket.created_at + 30.minutes, ticket.sla.deadline
    end
  end

  test "one edit affects future tickets across linked brands but not existing ones" do
    existing = [ticket_for(@a), ticket_for(@b)]
    @policy.update!(first_response_minutes: 90)
    [@a, @b].each { |brand| assert_equal 90, ticket_for(brand.reload).sla_target_minutes }
    existing.each { |ticket| assert_equal 30, ticket.reload.sla_target_minutes }
  end

  test "unlinked and independently linked brands are unaffected" do
    independent = SlaPolicy.create!(name: "Başka", first_response_minutes: 20)
    other = Brand.create!(name: "C", sla_policy: independent)
    default = Brand.create!(name: "D")
    @policy.update!(first_response_minutes: 90)
    assert_equal 20, ticket_for(other).sla_target_minutes
    assert_equal 60, ticket_for(default).sla_target_minutes
  end

  test "custom deadline has exact inclusive boundary using travel_to" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = ticket_for(@a)
      travel_to ticket.created_at + 30.minutes
      assert_not ticket.sla.overdue?
      travel 1.second
      assert ticket.sla.overdue?
    end
  end

  test "policy extension cannot erase an overdue or late reply breach" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = ticket_for(@a)
      travel 31.minutes
      @policy.update!(first_response_minutes: 120)
      assert ticket.reload.sla.overdue?
      ticket.update!(status: "open")
      ticket.ticket_responses.create!(body: "Geç yanıt", author_type: "staff")
      ticket.reload.update!(status: "solved")
      @policy.update!(first_response_minutes: 240)
      assert ticket.reload.sla.breached?
      assert_not ticket.sla.overdue?
    end
  end

  test "shortening policy cannot retroactively breach an on time ticket" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = ticket_for(@a)
      ticket.update!(status: "open")
      travel 20.minutes
      ticket.ticket_responses.create!(body: "Yanıt", author_type: "staff")
      @policy.update!(first_response_minutes: 5)
      assert_not ticket.reload.sla.breached?
    end
  end

  test "target and policy association validation reject invalid configuration" do
    [0, -1, 1441, 1.5, nil].each { |value| assert_not @policy.update(first_response_minutes: value) }
    assert_not SlaPolicy.new(first_response_minutes: 10).valid?
    assert_not @a.update(sla_policy_id: -1)
  end

  test "existing ticket snapshot cannot be edited" do
    ticket = ticket_for(@a)
    assert_not ticket.update(sla_target_minutes: 120)
    assert_equal 30, ticket.reload.sla_target_minutes
  end

  test "policy changes do not bypass new open solved transitions" do
    ticket = ticket_for(@a)
    @policy.update!(first_response_minutes: 45)
    assert_not ticket.update(status: "solved")
    ticket.reload.update!(status: "open")
    ticket.update!(status: "solved")
    assert_not ticket.update(status: "open")
  end
end
