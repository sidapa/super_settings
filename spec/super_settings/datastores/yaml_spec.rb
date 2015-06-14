require 'spec_helper'

describe SuperSettings::Datastores::Yaml do
  subject(:yaml) { SuperSettings::Datastores::Yaml.new(filename) }
  let(:filename) { 'test' }

  describe '::new' do
    it 'returns a Datastores::Yaml instance' do
      expect(File).to receive(:exist?).with(filename).and_return(true)
      expect(yaml.class).to eql(SuperSettings::Datastores::Yaml)
    end

    context 'file does not exist' do
      it 'throws an error' do
        allow(File).to receive(:exist?).with(filename).and_return(false)

        expect { yaml }.to raise_error SuperSettings::Error
      end
    end
  end

  describe '#load' do
    subject(:load_method) {  yaml.load }

    let(:json_data) do
      { feature_name:
        {
          default: true,
          foo: 'bar'
        }
      }.to_json
    end

    context 'with valid yaml file' do
      before(:each) do
        allow(File).to receive(:exist?).with(filename).and_return(true)
        allow(YAML).to receive(:load).and_return(json_data)
      end

      let(:feature_set) do
        SuperSettings::FeatureSet
      end

      it 'clears the feature sets' do
        expect(SuperSettings::FeatureSet).to receive(:reset!)
        load_method
      end

      it { expect(load_method).to eql(true) }
      it { expect(feature_set.respond_to? :feature_name).to eql(true) }
    end

    context 'with invalid yaml file' do
      before(:each) do
        allow(File).to receive(:exist?).with(filename).and_return(true)
        allow(YAML).to receive(:load).and_return(json_data)
      end

      let(:json_data) do
        { feature_name:
          {
            foo: 'bar'
          }
        }.to_json
      end

      it { expect { load_method }.to raise_error SuperSettings::Error }
    end
  end
end
