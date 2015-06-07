require 'yaml'
require 'json'

module SuperSettings
  module FeatureSetLoaders
    # Allows FeatureSet to load data from a yml file
    module YamlLoader
      module_function

      def call(configuration)
        return false unless configuration.datastore == :yaml

        fail Error if configuration.filename.nil?
        true
      end

      def features_json(filename)
        json_data = YAML.load(filename)

        JSON.parse(json_data)
      end
    end
  end
end
