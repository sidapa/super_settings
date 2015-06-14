require 'yaml'
require 'json'

module SuperSettings
  # Allows config loaders for feature sets
  module FeatureSetLoaders
    # Allows FeatureSet to load data from a yml file
    class YamlLoader
      def self.call(configuration)
        return false unless configuration.datastore_type == :yaml

        filename = configuration.filename
        fail Error if filename.nil?

        configuration.datastore = SuperSettings::Datastores::Yaml.new(filename)
        configuration.datastore.load
      end
    end

    SuperSettings::FeatureSet.add_config_parser(YamlLoader)
  end
end
