require 'spec_helper'

describe SuperSettings::FeatureSet do
  let(:parser) { parser_double }
  let(:parser_double) { double() }

  before(:each) { allow(parser_double).to receive(:call) }
  after(:each) { SuperSettings::FeatureSet.instance_variable_set(:@parsers, []) }

  describe '::config' do
    subject(:configuration) do
      SuperSettings::FeatureSet.instance_variable_get(:@configuration)
    end

    before(:each) do
      SuperSettings::FeatureSet.config do |config|
        config.foo = :bar
      end
    end

    it { expect(configuration.foo).to eql(:bar) }
    it 'parses the configuration' do
      expect(SuperSettings::FeatureSet).to receive(:parse_configuration)

      SuperSettings::FeatureSet.config do |config|
        config.foo = :bar
      end
    end
  end

  describe '::add_config_parser' do
    subject(:add_parser) { SuperSettings::FeatureSet.add_config_parser(parser) }
    let(:parsers) do
      SuperSettings::FeatureSet.instance_variable_get(:@parsers)
    end

    context 'Parser size' do
      it { expect { add_parser }.to change { parsers.size }.by(1) }
    end

    context 'Parser content' do
      before(:each) { add_parser }
      it { expect(parsers).to eql([parser]) }
    end

    context 'Added parser does not support the method ::call' do
      let(:parser) { String }

      it { expect { add_parser }.to raise_error SuperSettings::Error }
    end
  end

  describe '::parse_configuration' do
    before(:each) { SuperSettings::FeatureSet.add_config_parser(parser) }

    let(:configuration) do
      SuperSettings::FeatureSet.instance_variable_get(:@configuration)
    end

    subject(:run_parse) { SuperSettings::FeatureSet.parse_configuration }

    it 'calls the call method on each of the parsers' do
      expect(parser).to receive(:call).with(configuration)
      run_parse
    end
  end
end
