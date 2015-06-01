require 'spec_helper'

describe SuperSettings::RuleRegistry do
  before(:each) do
    # put registry in a temporary variable
    @settings_value_data = SuperSettings::RuleRegistry
                           .instance_variable_get('@value_data')
    SuperSettings::RuleRegistry.instance_variable_set('@value_data', Hash.new)
  end

  after(:each) do
    # return registry values
    SuperSettings::RuleRegistry
      .instance_variable_set('@value_data', @settings_value_data)
  end

  describe '.register' do
    let(:registered_hash) { { klass: 'test', method: 'only' } }
    let(:lookup_key) { :lookup_key }
    let(:register) do
      SuperSettings::RuleRegistry.register(lookup_key, registered_hash)
    end

    context 'valid parameters' do
      context 'with key that has not been registered' do
        subject(:registered_value) do
          SuperSettings::RuleRegistry
            .instance_variable_get('@value_data')[:lookup_key]
        end

        before(:each) { register }
        it { is_expected.to eql(registered_hash) }
      end

      context 'with ore than one keys' do
        subject(:registered_keys) do
          SuperSettings::RuleRegistry
            .instance_variable_get('@value_data').keys
        end
        let(:lookup_key) { [:key1, :key2] }

        before(:each) { register }
        it { is_expected.to eql(lookup_key) }
      end

      context 'with key that matches an existing method' do
        let(:lookup_key) { :methods }
        it { expect { register }.to raise_error }
      end

      it 'fails if key of the same name already exists' do
        register
        expect do
          SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)
        end.to raise_error
      end
    end

    context 'invalid parameters' do
      context 'malformed registered_hash' do
        context 'non hash value' do
          let(:registered_hash) { 'test' }
          it { expect { register }.to raise_error }
        end

        context 'no klass' do
          let(:registered_hash) { { k: 'no klass' } }
          it { expect { register }.to raise_error }
        end

        context 'no method' do
          let(:registered_hash) { { klass: 'no method' } }
          it { expect { register }.to raise_error }
        end
        context 'no method'
      end
    end

  end

  describe '.method_missing' do
    let(:class_double) { double }
    let(:registered_hash) { { klass: class_double, method: :only } }

    before(:each) do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)
    end

    it 'calls the appropriate class method and forwards value returned' do

      expect(class_double).to receive(:only)
      SuperSettings::RuleRegistry.lookup_key
    end

    context 'result_class' do
      let(:class_double) { double }
      let(:result_double) { double }
      let(:result_class_double) { class_double }

      let(:registered_hash) do
        { klass: class_double,
          method: :only,
          result_class: result_class_double }
      end

      before(:each) do
        allow(class_double).to receive(:only).and_return(result_double)
      end

      it 'calls new if parse is not supported' do
        expect(result_class_double).to receive(:new).with(result_double)
        SuperSettings::RuleRegistry.lookup_key
      end

      it 'shoves the result into a result class if it exists' do
        expect(result_class_double).to receive(:parse).with(result_double)
        SuperSettings::RuleRegistry.lookup_key
      end
    end

    context 'with block' do
      before(:each) do
        allow(class_double).to receive(:only).and_return(1)
      end

      let(:lookup_block) do
        SuperSettings::RuleRegistry.lookup_key do |v|
          v.to_s
        end
      end

      it 'passes the class value to a block if given' do
        expect(lookup_block).to eql('1')
      end
    end
  end

  describe '.rules' do
    let(:registered_hash) { { klass: double, method: :only } }
    it 'displays registered rules' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      expect(SuperSettings::RuleRegistry.rules).to eql([:lookup_key])
    end

    it 'fails if there are no registered rules' do
      expect { SuperSettings::RuleRegistry.rules }.to raise_error
    end
  end
end
