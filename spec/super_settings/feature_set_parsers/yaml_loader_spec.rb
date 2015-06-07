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
end
