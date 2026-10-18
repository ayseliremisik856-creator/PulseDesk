require "test_helper"

class MasterKeyTest < ActiveSupport::TestCase
  test "valid master key stays unchanged" do
    key = SecureRandom.hex(16)
    environment = { "RAILS_MASTER_KEY" => key }
    PulseDesk::MasterKey.normalize!(environment)
    assert_equal key, environment["RAILS_MASTER_KEY"]
  end

  test "clipboard outer whitespace is normalized without modifying secret key base" do
    key = SecureRandom.hex(16)
    secret_key_base = SecureRandom.hex(64)
    environment = { "RAILS_MASTER_KEY" => " \t#{key}\r\n", "SECRET_KEY_BASE" => secret_key_base }
    PulseDesk::MasterKey.normalize!(environment)
    assert_equal key, environment["RAILS_MASTER_KEY"]
    assert_equal secret_key_base, environment["SECRET_KEY_BASE"]
  end

  test "missing environment key allows Rails key file fallback" do
    environment = {}
    PulseDesk::MasterKey.normalize!(environment)
    assert_not environment.key?("RAILS_MASTER_KEY")
  end

  test "secret key base or malformed input is rejected without leaking values" do
    [ SecureRandom.hex(64), SecureRandom.hex(8), "", "z" * 32 ].each do |value|
      error = assert_raises(PulseDesk::MasterKey::InvalidFormat) do
        PulseDesk::MasterKey.normalize!({ "RAILS_MASTER_KEY" => value })
      end
      assert_not_includes error.message, value unless value.empty?
    end
  end

  test "quotes and assignment syntax are rejected rather than guessed" do
    key = SecureRandom.hex(16)
    [ "\"#{key}\"", "RAILS_MASTER_KEY=#{key}", "#{key[0, 16]} #{key[16, 16]}" ].each do |value|
      assert_raises(PulseDesk::MasterKey::InvalidFormat) { PulseDesk::MasterKey.normalize!({ "RAILS_MASTER_KEY" => value }) }
    end
  end
end
