require 'spec_helper'
require 'ostruct'

describe SuperSettings::FeatureSetLoaders::YamlLoader do
  describe '::call' do
    subject(:call_method) do
      SuperSettings::FeatureSetLoaders::YamlLoader.call(configuration)
    end

    let(:configuration) do
      OpenStruct.new(datastore: :yaml, filename: filename)
    end

    let(:filename) { 'test' }

    context 'complete data' do
      it { expect(call_method).to eql(true) }
    end

    context 'not configured' do
      let(:configuration) { OpenStruct.new(datastore: :not_yaml) }

      it { expect(call_method).to eql(false) }
    end

    context 'no filename' do
      let(:configuration) { OpenStruct.new(datastore: :yaml) }

      it { expect { call_method }.to raise_error SuperSettings::Error }
    end
  end

  describe '::features_json' do
    subject(:features_json_method) do
      SuperSettings::FeatureSetLoaders::YamlLoader.feature_json(filename)
    end

    let(:filename) { 'test' }

    context 'complete data' do
      it 'creates a JSON object from the YAML' do
        expect(YAML).to receive(:load).with(filename)
        expect(JSON).to receive(:parse)

        SuperSettings::FeatureSetLoaders::YamlLoader.features_json(filename)
      end
    end
  end
end
