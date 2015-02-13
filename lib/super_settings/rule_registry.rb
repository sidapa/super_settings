module SuperSettings
  # RuleRegistry contains allows super_settings users to register themselves
  class RuleRegistry
    @value_hash = {}

    class << self
      def register(key, value)
        fail "Key: #{key} already exists." if @value_hash.keys.include? key
        @value_hash[key] = value
      end
    end
  end
end
