require 'spec_helper'
require 'ostruct'

describe SuperSettings::FeatureSetLoaders::YamlLoader do
  let(:filename) { 'test' }

  before(:each) do
    allow(File).to receive(:exist?).with(filename).and_return true
  end

  describe '::call' do
    subject(:call_method) do
      SuperSettings::FeatureSetLoaders::YamlLoader.call(configuration)
    end

    let(:configuration) do
      OpenStruct.new(datastore_type: :yaml, filename: filename)
    end

    let(:json_data) do
      { feature_name:
        {
          default: true,
          foo: 'bar'
        }
      }.to_json
    end

    context 'complete data' do
      before(:each) do
        allow(YAML).to receive(:load).and_return(json_data)
      end

      let(:feature_set) do
        SuperSettings::FeatureSet
      end

      it { expect(call_method).to eql(true) }
      it { expect(feature_set.respond_to? :feature_name).to eql(true) }
    end

    context 'not configured' do
      let(:configuration) { OpenStruct.new(datastore_type: :not_yaml) }

      it { expect(call_method).to eql(false) }
    end

    context 'no filename' do
      let(:configuration) { OpenStruct.new(datastore_type: :yaml) }

      it { expect { call_method }.to raise_error SuperSettings::Error }
    end
  end

  describe '::new' do
    before(:each) do
      allow(File).to receive(:exist?).with(filename).and_return false
    end

    subject(:loader_instance) do
      SuperSettings::FeatureSetLoaders::YamlLoader.new(filename)
    end

    context 'file does not exist' do
      it 'fails if the file does not exist' do
        expect { loader_instance }.to raise_error SuperSettings::Error
      end
    end
  end

  describe '#features_json' do
    subject(:loader_instance) do
      SuperSettings::FeatureSetLoaders::YamlLoader.new(filename)
    end

    let(:json_double) { double }

    context 'complete data' do
      it 'creates a JSON object from the YAML' do
        expect(YAML).to receive(:load).with(filename)
        expect(JSON).to receive(:parse).and_return json_double

        expect(loader_instance.features_json).to eql(json_double)
      end
    end
  end
end
