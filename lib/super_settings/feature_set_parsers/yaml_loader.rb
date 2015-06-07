module SuperSettings
  module FeatureSetLoaders
    # Allows FeatureSet to load data from a yml file
    module YamlLoader
      def self.call(configuration)
        return false unless configuration.datastore == :yaml

        fail Error if configuration.filename.nil?
        true
      end
    end
  end
end
