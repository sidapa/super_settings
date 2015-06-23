module SuperSettings
  # Allows config loaders for feature sets
  module FeatureSetLoaders
    # Allows FeatureSet to load data from redis
    class RedisLoader
      def self.call(configuration)
        return false unless configuration.datastore_type == :redis
        configuration.datastore = SuperSettings::Datastores::Redis.new(configuration)
        configuration.datastore.load
      end
    end

    SuperSettings::FeatureSet.add_config_parser(RedisLoader)
  end
end
