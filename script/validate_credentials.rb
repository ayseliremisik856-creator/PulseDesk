# Validate without booting the application, connecting to PostgreSQL or revealing
# keys/plaintext. config/boot normalizes and checks the environment key first.
require_relative "../config/boot"
require "active_support/encrypted_file"
require "yaml"

root = File.expand_path("..", __dir__)
production_credentials = File.join(root, "config/credentials/production.yml.enc")
content = File.exist?(production_credentials) ? production_credentials : File.join(root, "config/credentials.yml.enc")
key_path = File.exist?(production_credentials) ? File.join(root, "config/credentials/production.key") : File.join(root, "config/master.key")

begin
  file = ActiveSupport::EncryptedFile.new(content_path: content, key_path: key_path, env_key: "RAILS_MASTER_KEY", raise_if_missing_key: true)
  data = YAML.safe_load(file.read)
  abort "Credentials validation failed: secret_key_base missing. No values displayed." unless data.is_a?(Hash) && data["secret_key_base"].is_a?(String) && !data["secret_key_base"].empty?
  abort "Credentials validation failed: master key and SECRET_KEY_BASE must be different. No values displayed." if ENV["SECRET_KEY_BASE"] && ENV["SECRET_KEY_BASE"] == file.key
rescue ActiveSupport::MessageEncryptor::InvalidMessage, ActiveSupport::EncryptedFile::MissingKeyError, ActiveSupport::EncryptedFile::MissingContentError, ArgumentError, Psych::Exception
  abort "Credentials validation failed: RAILS_MASTER_KEY cannot open the existing credentials. Replace the Render environment value with the matching local config/master.key; do not regenerate credentials. No values displayed."
end

puts "Credentials validation passed: existing ciphertext decrypted; secret_key_base present. No values displayed."
