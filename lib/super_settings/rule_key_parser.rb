module SuperSettings
  # RuleKeyParser parses rule keys. It takes in either a symbol
  # or an array of symbols and parses through them, returning
  # an array of symbols for registration
  class RuleKeyParser
    attr_accessor :keys
    def initialize(params)
      arr_params = Array(params)
      valid_params = %w(String Symbol)

      @keys = arr_params.map do |param|
        unless valid_params.include? param.class.to_s
          fail SuperSettings::Error, 'Invalid Parameter'
        end

        param.to_sym
      end

      @keys.uniq!
    end
  end
end
