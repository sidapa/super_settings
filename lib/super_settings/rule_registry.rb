module SuperSettings
  # RuleRegistry contains allows super_settings users to register themselves
  # TODO: allow contexts for RuleRegistry
  #       user_rule = SuperSettings::RuleRegistry.new(:users)
  #       vehicle_rule  = SuperSettings::RuleRegistry.new(:vehicles)
  #       vehicle_rule.wheel_count != user_rule.wheel_count
  module RuleRegistry
    extend SuperSettings::AllowRegistration
    extend SuperSettings::AllowMethodMissingOverride

    validate_value_with :must_be_hash
    validate_value_with :must_have_required_keys

    module_function

    def must_be_hash(value)
      fail 'Value needs to be a hash.' unless value.is_a? Hash
    end

    def must_have_required_keys(value)
      [:klass, :method].each do |hash_key|
        unless value.keys.include? hash_key
          fail "#{hash_key} key in registered value required."
        end
      end
    end

    def process_value(value, *args, &block)
      result_value = value[:klass]
                     .public_send(value[:method], *args, &block)

      parse_result(value[:result_class], result_value)
    end

    def rules
      value_hash.keys.tap do |keys|
        fail 'SuperSettings::RuleRegistry contains no rules' if keys.empty?
      end
    end

    def parse_result(klass, value)
      if klass
        parsing_method = klass.respond_to?(:parse) ? :parse : :new
        value = klass.public_send(parsing_method, value)
      end

      value
    end
  end
end
