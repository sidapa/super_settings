require 'spec_helper'

describe SuperSettings::FeatureSet do
  let(:parser) { parser_double }
  let(:parser_double) { double }

  before(:each) { allow(parser_double).to receive(:call) }
  after(:each) do
    SuperSettings::FeatureSet.instance_variable_set(:@parsers, [])
  end

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

  describe 'feature usage' do
    subject(:add_feature_method) do
      SuperSettings::FeatureSet.add_feature(feature_name, feature)
    end

    let(:feature) { SuperSettings::Feature.new set_value }
    let(:feature_name) { :foo }
    let(:value_data) { SuperSettings::FeatureSet.value_data }
    let(:set_value) { true }

    after(:each) { SuperSettings::FeatureSet.reset! }

    describe '::add_feature' do
      it { expect { add_feature_method }.to change { value_data.size }.by(1) }
    end

    describe '::process_value' do
      let(:block_double) { double }

      it 'uses the feature passed' do
        add_feature_method
        expect(SuperSettings::FeatureSet.foo).to eql(set_value)
      end

      context 'block calls' do
        before(:each) { add_feature_method }

        context 'if passed value is true' do
          it 'runs the block code' do
            expect(block_double).to receive(:test).with(set_value)
            SuperSettings::FeatureSet.foo do |val|
              block_double.test val
            end
          end
        end

        context 'if passed value is false' do
          let(:set_value) { false }

          it 'does not run the block code' do
            expect(SuperSettings::FeatureSet.foo { 1 }).not_to eql(1)
          end
        end
      end
    end

    describe '::keys' do
      subject(:keys) { SuperSettings::FeatureSet.keys }

      before(:each) { add_feature_method }

      it { is_expected.to eql(Array(feature_name)) }
    end

    describe '::export' do
      subject(:export_method) do
        SuperSettings::FeatureSet.export
      end

      before(:each) { add_feature_method }

      let(:feature_hash) do
        { feature_name => set_value }
      end

      it { is_expected.to eql(feature_hash) }
    end
  end
end
