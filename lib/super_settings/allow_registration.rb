module SuperSettings
  # AllowRegistration provides a class using it registration
  # functionality
  module AllowRegistration
    def value_data
      @value_data ||= {}
    end

    def validate_value_with(validators)
      # TODO: @validators_list could be its own class or
      # a validator could be its own class
      @validators_list = [] if @validators_list.nil?

      Array(validators).each do |validator|
        unless validator.is_a? Symbol
          fail Error, 'validate_value_with needs a symbol'
        end

        if @validators_list.include? validator
          fail Error, "#{validator} has already been defined"
        end

        @validators_list << validator
      end
    end

    def run_validations(value)
      return true if @validators_list.nil? || @validators_list.empty?
      @validators_list.each do |validator_method|
        public_send(validator_method, value)
      end
    end

    def register(key, value)
      return unless run_validations(value)
      RuleKeyParser.new(key).keys.each { |k| register_single(k, value) }
    end

    def register_single(key, value)
      fail "Key: #{key} already exists." if value_data.keys.include? key

      # TODO: Only check for exiting methods if also using method_missing
      fail "Method name: #{key} exists." if methods.include? key
      value_data[key] = value
    end
  end
end
