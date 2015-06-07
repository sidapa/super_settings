require 'yaml'
require 'json'

module SuperSettings
  module FeatureSetLoaders
    # Allows FeatureSet to load data from a yml file
    class YamlLoader
      def self.call(configuration)
        return false unless configuration.datastore == :yaml

        filename = configuration.filename
        fail Error if filename.nil?

        new(filename).load_data
      end

      def initialize(filename)
        fail Error, "#{filename} not found." unless File.exist?(filename)

        @filename = filename
      end

      def load_data
        features_json.each_pair do |k, v|
          feature = SuperSettings::Feature.new(symbolize_hash(v))
          SuperSettings::FeatureSet.add_feature(k.to_sym, feature)
        end

        true
      end

      def features_json
        json_data = YAML.load(@filename)

        JSON.parse(json_data)
      end

      private

      def symbolize_hash(hash_value)
        hash_value.each_with_object({}) do |(key, value), memo|
          memo[key.to_sym] = value
        end
      end
    end
  end
end
