require 'ostruct'

module SuperSettings
  # This class allows for feature toggles
  class FeatureSet
    extend SuperSettings::AllowRegistration
    extend SuperSettings::AllowMethodMissingOverride

    # TODO: create a class that deals with contexts

    class << self
      attr_accessor :configuration

      def config
        @configuration ||= OpenStruct.new
        yield @configuration
        parse_configuration
      end

      def parse_configuration
        # Do nothing for now. Maybe iterate over the
        # different parsers and pass configuration into those
        # those parsers would then perfom their own checks on
        # the configuration object. Or maybe create a new
        # configuration object completely?
      end
    end
  end
end
