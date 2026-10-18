module PulseDesk
  module MasterKey
    class InvalidFormat < StandardError; end

    # Rails strips key files, but not RAILS_MASTER_KEY. Clipboard/form input can
    # add outer newlines; remove only those, never truncate or replace a key.
    def self.normalize!(environment = ENV)
      value = environment["RAILS_MASTER_KEY"]
      return if value.nil?

      normalized = value.strip
      unless normalized.match?(/\A[0-9a-fA-F]{32}\z/)
        raise InvalidFormat, "RAILS_MASTER_KEY must contain the 32 hex characters from config/master.key. Do not use SECRET_KEY_BASE, quotes or an assignment. Value withheld."
      end
      environment["RAILS_MASTER_KEY"] = normalized
    end
  end
end
