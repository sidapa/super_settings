module SuperSettings
  # RuleRegistry contains allows super_settings users to register themselves
  # TODO: allow contexts for RuleRegistry
  #       user_rule = SuperSettings::RuleRegistry.new(:users)
  #       vehicle_rule  = SuperSettings::RuleRegistry.new(:vehicles)
  #       vehicle_rule.wheel_count != user_rule.wheel_count
  class RuleRegistry
    @value_hash = {}

    class << self
      def method_missing(method_sym, *args, &block)
        super unless @value_hash.keys.include? method_sym

        # TODO: class_eval a new method to skip method missing for next calls

        result_hash = @value_hash[method_sym]
        result_hash[:klass].send(result_hash[:method], *args, &block)
      end

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

      def rules
        @value_hash.keys.tap do |keys|
          fail 'SuperSettings::RuleRegistry contains no rules' if keys.empty?
        end
      end
    end
  end
end
