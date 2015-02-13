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
    let(:registered_hash) { { test: 'only' } }
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
  end
end
