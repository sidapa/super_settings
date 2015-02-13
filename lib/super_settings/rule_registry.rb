module SuperSettings
  # RuleRegistry contains allows super_settings users to register themselves
  class RuleRegistry
    @value_hash = {}

    class << self
      def register(key, value)
        fail "Key: #{key} already exists." if @value_hash.keys.include? key

        fail 'Value needs to be a hash.' unless value.is_a? Hash

        [:klass, :method].each do |hash_key|
          unless value.keys.include? hash_key
            fail "#{hash_key} key in registered value required."
          end
        end

        @value_hash[key] = value
      end
    end
  end
end
