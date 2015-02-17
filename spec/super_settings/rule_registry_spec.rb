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

  context '.register' do
    let(:registered_hash) { { klass: 'test', method: 'only' } }
    it 'should allow a rule to be registered to a lookup key' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      lookup_result = SuperSettings::RuleRegistry
                      .instance_variable_get('@value_hash')[:lookup_key]
      expect(lookup_result).to eql(registered_hash)
    end

    it 'should raise an error if key already exists' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      expect { SuperSettings::RuleRegistry.register(:lookup_key, 'test_value') }
        .to raise_error
    end

    it 'should raise error if passing a non Hash value' do
      expect { SuperSettings::RuleRegistry.register(:lookup_key, 'test') }
        .to raise_error
    end

    it 'should raise error if registered hash is malformed' do
      bad_hashes =  [{ k: 'no klass' }, { klass: 'no method' }]

      bad_hashes.each do |bad_hash|
        expect { SuperSettings::RuleRegistry.register(:lookup_key, bad_hash) }
          .to raise_error
      end
    end

    it 'should raise error if registering an existing method as key' do
      expect { SuperSettings::RuleRegistry.register(:methods, registered_hash) }
        .to raise_error
    end
  end

  context '.method_missing' do
    let(:class_double) { double  }
    let(:registered_hash) { { klass: class_double, method: :only } }
    it 'should call the appropriate class method and forward value returned' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      expect(class_double).to receive(:only)
      SuperSettings::RuleRegistry.lookup_key
    end
  end

  context '.rules' do
    let(:registered_hash) { { klass: double, method: :only } }
    it 'display registered rules' do
      SuperSettings::RuleRegistry.register(:lookup_key, registered_hash)

      expect(SuperSettings::RuleRegistry.rules).to eql([:lookup_key])
    end

    it 'should fail if there are no registered rules' do
      expect { SuperSettings::RuleRegistry.rules }.to raise_error
    end
  end
end
