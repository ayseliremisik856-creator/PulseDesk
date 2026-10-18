# Reads only numeric usage and metadata from one explicitly supplied local session.
# Raw prompts, responses, tool output, authentication and billing files stay private.
require "json"
require "time"

path, cutoff = ARGV
abort "Usage: ruby script/audit_codex_usage.rb SESSION_JSONL CUTOFF_UTC" unless path && cutoff
cutoff = Time.iso8601(cutoff)
fields = %w[input_tokens cached_input_tokens cache_write_input_tokens output_tokens reasoning_output_tokens total_tokens]
totals = fields.to_h { |key| [key, 0] }
groups = %w[short long].to_h { |key| [key, { "requests" => 0, "input" => 0, "cached" => 0, "output" => 0 }] }
seen = {}
models = []
first = last = session_start = nil
last_total = nil
valid_scope = false
File.foreach(path) do |line|
  event = JSON.parse(line)
  next if Time.iso8601(event.fetch("timestamp")) > cutoff
  payload = event["payload"] || {}
  case event["type"]
  when "session_meta"
    valid_scope = payload.fetch("cwd").tr("\\", "/").casecmp?(Dir.pwd.tr("\\", "/"))
    abort "Session belongs to a different workspace; audit stopped" unless valid_scope
    session_start = event["timestamp"]
  when "turn_context"
    models |= [payload["model"]].compact
  when "token_usage_record"
    abort "Missing workspace metadata" unless valid_scope
    next if seen[payload.fetch("response_id")]
    seen[payload.fetch("response_id")] = true
    usage = payload.fetch("usage")
    fields.each { |key| totals[key] += usage.fetch(key, 0) }
    first ||= event["timestamp"]
    last = event["timestamp"]
    last_total = payload.fetch("thread_token_usage")
    group = groups.fetch(usage.fetch("input_tokens") > 272_000 ? "long" : "short")
    group["requests"] += 1
    group["input"] += usage.fetch("input_tokens")
    group["cached"] += usage.fetch("cached_input_tokens")
    group["output"] += usage.fetch("output_tokens")
  end
end
abort "No usage records" if seen.empty?
abort "Cumulative usage mismatch" unless fields.all? { |key| totals[key] == last_total.fetch(key, 0) }
# Standard API equivalent only, assuming US/default endpoint and no extra tool fees.
# Cache writes are absent in this captured sample; reject instead of mispricing them.
abort "Pricing needs review for this model/cache-write usage" unless models == ["gpt-6.1-sol"] && totals["cache_write_input_tokens"].zero?
cost = groups.sum do |name, group|
  input_rate, cache_rate, output_rate = name == "long" ? [4.0, 0.2, 15.0] : [2.0, 0.1, 10.0]
  ((group["input"] - group["cached"]) * input_rate + group["cached"] * cache_rate + group["output"] * output_rate) / 1_000_000
end
puts JSON.pretty_generate({
  scope: "One local PulseDesk Codex Desktop session; not an invoice or all-account usage",
  cutoff_utc: cutoff.iso8601, session_start_utc: session_start,
  first_usage_utc: first, last_usage_utc: last, models: models,
  unique_responses: seen.size, totals: totals,
  uncached_input_tokens: totals["input_tokens"] - totals["cached_input_tokens"],
  context_groups: groups, cumulative_cross_check: true,
  standard_api_equivalent_usd: cost.round(6), actual_paid_usd: nil,
  pricing_source: "https://developers.openai.com/api/docs/models/gpt-6.1-sol"
})
