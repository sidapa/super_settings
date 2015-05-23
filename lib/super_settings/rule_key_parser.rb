module SuperSettings
  # RuleKeyParser parses rule keys. It takes in either a symbol
  # or an array of symbols and parses through them, returning
  # an array of symbols for registration
  class RuleKeyParser
    attr_accessor :value
    def initialize(params)
      arr_params = Array(params)
      valid_params = %w(String Symbol)

      @value = arr_params.map do |param|
        parameter_failure! unless valid_params.include? param.class.to_s
        param.to_sym
      end

      @value.uniq!
    end

    private

    def parameter_failure!
      fail SuperSettings::Error, 'Invalid Parameter'
    end
  end
end
