require 'redis'

module SuperSettings
  module Datastores
    # This class allows SuperSettings::FeatureSets to use the YAML datastore
    class Redis
      def initialize(config)
        return false unless config.datastore_type == :redis

        @datastore = ::Redis.new load_config(config)
      end

      def load
        true
      end

      private

      def load_config(config)
        {}.tap do |redis_config|
          %i(host port db hash_name).each do |param|
            redis_config[param] = config.fetch! param
          end
        end
      end
    end
  end
end
