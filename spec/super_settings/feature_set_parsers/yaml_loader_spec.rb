require 'spec_helper'

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
      SuperSettings::Config.new(datastore_type: :yaml, filename: filename)
    end

    context 'complete data' do
      let(:yaml_double) { double(load: true) }

      before(:each) do
        allow(SuperSettings::Datastores::Yaml).to receive(:new)
          .and_return(yaml_double)
        call_method
      end

      it { expect(configuration.respond_to? :datastore).to eql(true) }
      it { expect(configuration.datastore).to eql(yaml_double) }
      it { expect(call_method).to eql(true) }
    end

    context 'not configured' do
      let(:configuration) do
        SuperSettings::Config.new(datastore_type: :not_yaml)
      end

      it { expect(call_method).to eql(false) }
    end

    context 'no filename' do
      let(:configuration) { SuperSettings::Config.new(datastore_type: :yaml) }

      it { expect { call_method }.to raise_error SuperSettings::Error }
    end
  end
end
