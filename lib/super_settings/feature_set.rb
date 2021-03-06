module SuperSettings
  # This class allows for feature toggles
  module FeatureSet
    extend SuperSettings::AllowRegistration
    extend SuperSettings::AllowMethodMissingOverride

    # TODO: create a class that deals with contexts

    module_function

    @parsers = []

    def config
      @configuration ||= SuperSettings::Config.new
      yield @configuration
      parse_configuration
    end

    def parse_configuration
      @parsers.uniq.each do |parser|
        parser.call(@configuration)
      end
    end

    def add_config_parser(parser)
      fail Error, 'call method required' unless parser.respond_to? :call
      @parsers << parser
    end

    def add_feature(name, feature)
      register(name, feature)
    end

    def process_value(value, *args)
      toggle_value = value.send(:set?, *args)
      block_given? && toggle_value ? yield(toggle_value) : toggle_value
    end
  end
end
