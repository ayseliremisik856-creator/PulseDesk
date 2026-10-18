# Run only against a disposable PostgreSQL database (used by GitHub Actions).
abort "Production environment required" unless Rails.env.production?
abort "PostgreSQL required" unless ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
abort "Unexpected database roles" unless ActiveRecord::Base.configurations.configs_for(env_name: "production").map(&:name) == [ "primary" ]
abort "Unexpected cache" unless Rails.cache.is_a?(ActiveSupport::Cache::MemoryStore)
abort "Unexpected queue" unless ActiveJob::Base.queue_adapter.is_a?(ActiveJob::QueueAdapters::InlineAdapter)
abort "Unexpected cable" unless ActionCable.server.config.cable.fetch("adapter") == "async"

Ticket.transaction do
  brand = Brand.create!(name: "CI smoke")
  agent = Agent.create!(name: "CI agent", email: "ci-#{SecureRandom.hex(8)}@example.com")
  ticket = Ticket.create!(brand: brand, subject: "Production smoke", description: "Database workflow", customer_name: "CI", customer_email: "ci@example.com", created_at: 61.minutes.ago)
  abort "Initial state or SLA incorrect" unless ticket.status == "new" && ticket.sla.overdue?
  abort "Invalid transition accepted" if ticket.update(status: "solved")
  ticket.reload.update!(agent: agent)
  ticket.update!(status: "open")
  ticket.ticket_responses.create!(body: "Reply", author_type: "staff")
  ticket.reload.update!(status: "solved")
  abort "Workflow or persistent SLA breach incorrect" unless ticket.reload.status == "solved" && ticket.first_response_at && ticket.sla.breached? && !ticket.sla.overdue?
  raise ActiveRecord::Rollback
end

puts "Production PostgreSQL workflow smoke passed (transaction rolled back)."
