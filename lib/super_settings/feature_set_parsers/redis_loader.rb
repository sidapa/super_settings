module SuperSettings
  # Allows config loaders for feature sets
  module FeatureSetLoaders
    # Allows FeatureSet to load data from redis
    class RedisLoader
      def self.call(config)
        return false unless config.datastore_type == :redis
        config.datastore = SuperSettings::Datastores::Redis.new(config)
        config.datastore.load
      end
    end

    SuperSettings::FeatureSet.add_config_parser(RedisLoader)
  end
end
