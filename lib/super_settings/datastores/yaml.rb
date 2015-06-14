module SuperSettings
  module Datastores
    # This class allows SuperSettings::FeatureSets to use the YAML datastore
    class Yaml
      def initialize(filename)
        fail Error, "#{filename} not found." unless File.exist?(filename)

        @filename = filename
      end

      def load
        SuperSettings::FeatureSet.reset!

        features_json.each_pair do |k, v|
          feature = SuperSettings::Feature.new(symbolize_hash(v))
          SuperSettings::FeatureSet.add_feature(k.to_sym, feature)
        end

        true
      end

      private

      def features_json
        json_data = YAML.load(@filename)

        JSON.parse(json_data)
      end

      def symbolize_hash(hash_value)
        hash_value.each_with_object({}) do |(key, value), memo|
          memo[key.to_sym] = value
        end
      end
    end
  end
end
