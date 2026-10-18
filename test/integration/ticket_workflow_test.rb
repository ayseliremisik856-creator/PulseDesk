require "test_helper"

class TicketWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    @brand = Brand.create!(name: "Pulse")
    @agent = Agent.create!(name: "Ece", email: "ece@example.com")
    @attributes = { subject: "Fatura yardımı", description: "Faturamı bulamıyorum", customer_name: "Deniz", customer_email: "deniz@example.com", brand_id: @brand.id, priority: "high" }
  end

  test "create assign open reply and solve through HTTP" do
    get root_path
    assert_response :success
    assert_select ".logo", text: /PulseDesk/
    get new_ticket_path
    assert_response :success
    assert_difference "Ticket.count", 1 do
      post tickets_path, params: { ticket: @attributes.merge(status: "solved", first_response_at: Time.current) }
    end
    ticket = Ticket.order(:id).last
    assert_equal "new", ticket.status
    assert_nil ticket.first_response_at
    follow_redirect!
    assert_response :success
    assert_select "h1", "Fatura yardımı"
    patch ticket_path(ticket), params: { ticket: { agent_id: @agent.id } }
    assert_redirected_to ticket_path(ticket)
    assert_equal @agent, ticket.reload.agent
    patch ticket_path(ticket), params: { ticket: { status: "open" } }
    assert_equal "open", ticket.reload.status
    follow_redirect!
    assert_select "textarea[name='ticket_response[body]']"
    assert_difference "TicketResponse.count", 1 do
      post ticket_ticket_responses_path(ticket), params: { ticket_response: { body: "Faturanızı gönderdim", author_type: "staff" } }
    end
    assert_not_nil ticket.reload.first_response_at
    follow_redirect!
    assert_select ".response", text: /Faturanızı gönderdim/
    patch ticket_path(ticket), params: { ticket: { status: "solved" } }
    assert_equal "solved", ticket.reload.status
    follow_redirect!
    assert_select ".badge.solved", "Çözüldü"
    get root_path
    assert_response :success
    assert_select "a", text: /Fatura yardımı/
  end

  test "invalid creation displays errors without saving" do
    assert_no_difference "Ticket.count" do
      post tickets_path, params: { ticket: @attributes.merge(subject: "", customer_email: "invalid") }
    end
    assert_response :unprocessable_entity
    assert_select "[role=alert]"
  end

  test "skipped transition and invalid assignment fail through HTTP" do
    ticket = Ticket.create!(@attributes)
    patch ticket_path(ticket), params: { ticket: { status: "solved" } }
    assert_response :unprocessable_entity
    assert_equal "new", ticket.reload.status
    patch ticket_path(ticket), params: { ticket: { agent_id: -1 } }
    assert_response :unprocessable_entity
    assert_nil ticket.reload.agent_id
  end

  test "invalid response does not stop SLA" do
    ticket = Ticket.create!(@attributes)
    ticket.update!(status: "open")
    assert_no_difference "TicketResponse.count" do
      post ticket_ticket_responses_path(ticket), params: { ticket_response: { body: "", author_type: "staff" } }
    end
    assert_response :unprocessable_entity
    assert_nil ticket.reload.first_response_at
  end

  test "dashboard and detail display overdue and persistent late reply breach" do
    travel_to Time.zone.local(2026, 10, 19, 10) do
      ticket = Ticket.create!(@attributes)
      ticket.update!(status: "open")
      travel 61.minutes
      get root_path
      assert_response :success
      assert_select "td.danger", text: /Overdue/
      get ticket_path(ticket)
      assert_select ".sla-panel", text: /Overdue/
      post ticket_ticket_responses_path(ticket), params: { ticket_response: { body: "Merhaba", author_type: "staff" } }
      follow_redirect!
      assert_select ".sla-panel", text: /SLA ihlali/
      get root_path
      assert_select "td.danger", text: /geç yanıtlandı/
    end
  end

  test "brand and agent can be created from dashboard" do
    assert_difference "Brand.count", 1 do
      post brands_path, params: { brand: { name: "Yeni marka" } }
    end
    assert_redirected_to root_path
    assert_difference "Agent.count", 1 do
      post agents_path, params: { agent: { name: "Can", email: "can@example.com" } }
    end
    follow_redirect!
    assert_response :success
    assert_select "p", text: /Can/
  end

  test "health check succeeds" do
    get rails_health_check_path
    assert_response :success
  end
end
