module SuperSettings
  # RuleRegistry contains allows super_settings users to register themselves
  # TODO: allow contexts for RuleRegistry
  #       user_rule = SuperSettings::RuleRegistry.new(:users)
  #       vehicle_rule  = SuperSettings::RuleRegistry.new(:vehicles)
  #       vehicle_rule.wheel_count != user_rule.wheel_count
  module AutoCallable
    def value_hash
      fail NotImplementedError, 'value_hash required by SuperSettings::AutoCallable'
    end

    def method_missing(method_sym, *args, &block)
      super unless value_hash.keys.include? method_sym

      # TODO: class_eval a new method to skip method missing for next calls

      result_hash = value_hash[method_sym]
      result_value = result_hash[:klass]
                     .send(result_hash[:method], *args, &block)

      parse_result(result_hash[:result_class], result_value)
    end
  end

  module Registerable
    def value_hash
      fail NotImplementedError, 'value_hash required by SuperSettings::Registerable'
    end

    def value_validator(value)
      fail NotImplementedError, 'value_validator required by SuperSettings::Registerable'
    end

    def register(key, value)
      value_validator(value)

      RuleKeyParser.new(key).keys.each { |k| register_single(k, value) }
    end

    def register_single(key, value)
      fail "Key: #{key} already exists." if value_hash.keys.include? key

      # TODO: Only check for exiting methods if also using method_missing
      fail "Method name: #{key} exists." if methods.include? key
      value_hash[key] = value
    end
  end

  class RuleRegistry
    extend SuperSettings::Registerable
    extend SuperSettings::AutoCallable

    @value_hash = {}

    class << self
      def value_hash
        @value_hash
      end

      def value_validator(value)
        fail 'Value needs to be a hash.' unless value.is_a? Hash

        [:klass, :method].each do |hash_key|
          unless value.keys.include? hash_key
            fail "#{hash_key} key in registered value required."
          end
        end
      end

      def rules
        value_hash.keys.tap do |keys|
          fail 'SuperSettings::RuleRegistry contains no rules' if keys.empty?
        end
      end

      def parse_result(klass, value)
        if klass
          parsing_method = klass.respond_to?(:parse) ? :parse : :new
          value = klass.send(parsing_method, value)
        end

        value
      end
    end
  end
end
