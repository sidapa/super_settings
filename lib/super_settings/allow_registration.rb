module SuperSettings
  module AllowRegistration
    def value_hash
      fail NotImplementedError, 'value_hash required by SuperSettings::Registerable'
    end

    # This method will check value and raise errors if value fails validation.
    # TODO: turn this into a helper_method a la ActiveRecord's .validates
    # - Add validations array which gets called in order. each entry points to 
    # a method implemented by the child class
    def validate_value(value)
      fail NotImplementedError, 'value_validator required by SuperSettings::Registerable'
    end

    def register(key, value)
      validate_value(value)

      RuleKeyParser.new(key).keys.each { |k| register_single(k, value) }
    end

    def register_single(key, value)
      fail "Key: #{key} already exists." if value_hash.keys.include? key

      # TODO: Only check for exiting methods if also using method_missing
      fail "Method name: #{key} exists." if methods.include? key
      value_hash[key] = value
    end
  end
end
