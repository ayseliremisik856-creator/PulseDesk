require "test_helper"

class SharedSlaWorkflowTest < ActionDispatch::IntegrationTest
  test "create policy attach two brands and edit once through HTTP" do
    a = Brand.create!(name: "HTTP A")
    b = Brand.create!(name: "HTTP B")
    get sla_policies_path
    assert_response :success
    assert_difference "SlaPolicy.count", 1 do
      post sla_policies_path, params: { sla_policy: { name: "Paylaşılan", first_response_minutes: 30 } }
    end
    policy = SlaPolicy.last
    [a, b].each do |brand|
      patch brand_path(brand), params: { brand: { sla_policy_id: policy.id } }
      assert_redirected_to sla_policies_path
      assert_equal policy, brand.reload.sla_policy
    end
    patch sla_policy_path(policy), params: { sla_policy: { first_response_minutes: 45 } }
    assert_redirected_to sla_policies_path
    [a, b].each do |brand|
      post tickets_path, params: { ticket: { brand_id: brand.id, subject: "Ortak hedef", description: "Test", customer_name: "Test", customer_email: "test@example.com", sla_target_minutes: 999 } }
      assert_response :redirect
      assert_equal 45, Ticket.last.sla_target_minutes
      follow_redirect!
      assert_select ".sla-panel", text: /45 dakika/
    end
  end

  test "invalid policy edit renders errors and preserves target" do
    policy = SlaPolicy.create!(name: "Geçerli", first_response_minutes: 30)
    patch sla_policy_path(policy), params: { sla_policy: { first_response_minutes: 0 } }
    assert_response :unprocessable_entity
    assert_equal 30, policy.reload.first_response_minutes
    assert_select "[role=alert]"
  end

  test "unbinding policy returns future tickets to default without rewriting old ones" do
    policy = SlaPolicy.create!(name: "Kısa", first_response_minutes: 15)
    brand = Brand.create!(name: "A", sla_policy: policy)
    old = Ticket.create!(brand: brand, subject: "Eski", description: "Test", customer_name: "Test", customer_email: "test@example.com")
    patch brand_path(brand), params: { brand: { sla_policy_id: "" } }
    assert_redirected_to sla_policies_path
    assert_nil brand.reload.sla_policy
    assert_equal 60, brand.first_response_minutes
    assert_equal 15, old.reload.sla_target_minutes
  end
end
