require 'redis'
require 'json'

module SuperSettings
  module Datastores
    # This class allows SuperSettings::FeatureSets to use the YAML datastore
    class Redis
      def initialize(config)
        return false unless config.datastore_type == :redis
        @config = config
        @datastore = ::Redis.new load_config
      end

      def load
        SuperSettings::FeatureSet.reset!
        keys.each do |key|
          SuperSettings::FeatureSet.add_feature(key, fetch_data(key))
        end
        true
      end

      private

      def hash_name
        @hash_name ||= @config.fetch! 'hash_name'
      end

      def keys
        @datastore.hkeys(hash_name).map(&:to_sym)
      end

      def fetch_data(feature_key)
        result = @datastore.hget hash_name, feature_key.to_sym
        JSON.parse(result).each_with_object({}) do |(key, value), new_hash|
          new_hash[key.to_sym] = value
        end
      end

      def load_config
        {}.tap do |redis_config|
          [:host, :port, :db].each do |param|
            redis_config[param] = @config.fetch! param
          end
        end
      end
    end
  end
end
