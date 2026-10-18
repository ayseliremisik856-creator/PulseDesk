require "test_helper"

class AgentTest < ActiveSupport::TestCase
  test "email is normalized and unique" do
    agent = Agent.create!(name: "Ece", email: " ECE@example.com ")
    assert_equal "ece@example.com", agent.email
    assert_not Agent.new(name: "Other", email: "ECE@example.com").valid?
  end

  test "brand and agent require valid attributes" do
    assert_not Brand.new.valid?
    assert_not Agent.new(name: "Ece", email: "invalid").valid?
    assert_not Agent.new(email: "ece@example.com").valid?
  end
end
