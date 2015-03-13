require 'spec_helper'

describe SuperSettings::RuleRegistry do
  before(:each) do
    # put registry in a temporary variable
    @settings_value_hash = SuperSettings::RuleRegistry
                           .instance_variable_get('@value_hash')
    SuperSettings::RuleRegistry.instance_variable_set('@value_hash', Hash.new)
  end

  after(:each) do
    # return registry values
    SuperSettings::RuleRegistry
      .instance_variable_set('@value_hash', @settings_value_hash)
  end

  describe '.register' do
    let(:registered_hash) { { klass: 'test', method: 'only' } }

    it 'allows a rule to be registered to a lookup key' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      lookup_result = SuperSettings::RuleRegistry
                      .instance_variable_get('@value_hash')[:lookup_key]
      expect(lookup_result).to eql(registered_hash)
    end

    it 'fails if key of the same name already exists' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      expect { SuperSettings::RuleRegistry.register(:lookup_key, 'test_value') }
        .to raise_error
    end

    it 'fails if passed a non Hash value' do
      expect { SuperSettings::RuleRegistry.register(:lookup_key, 'test') }
        .to raise_error
    end

    it 'fails if the registered hash is malformed' do
      bad_hashes =  [{ k: 'no klass' }, { klass: 'no method' }]

      bad_hashes.each do |bad_hash|
        expect { SuperSettings::RuleRegistry.register(:lookup_key, bad_hash) }
          .to raise_error
      end
    end

    it 'fails if an existing method is registered as key' do
      expect { SuperSettings::RuleRegistry.register(:methods, registered_hash) }
        .to raise_error
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
