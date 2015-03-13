require 'spec_helper'

describe SuperSettings::Calculate do
  before(:each) do
    # put registry in a temporary variable
    @operators_value_hash = SuperSettings::Calculate
                            .instance_variable_get('@operators')
    SuperSettings::Calculate.instance_variable_set('@operators', Hash.new)
  end

  after(:each) do
    # return registry values
    SuperSettings::Calculate
      .instance_variable_set('@operators', @operators_value_hash)
  end

  describe '.method_missing' do
    it 'calls a registered operator if no method was found'
  end

  describe '.register' do
    let(:registered_op) { { klass: 'test', method: 'only' } }

    before(:each) do
      SuperSettings::Calculate.register(:lookup_key, registered_op)
    end

    it 'allows an operator to be registered' do
      lookup_result = SuperSettings::Calculate
                      .instance_variable_get('@operators')[:lookup_key]
      expect(lookup_result).to eql(registered_op)
    end

    it 'fails when registering an already registered operator' do
      expect { SuperSettings::Calculate.register(:lookup_key, registered_op) }
        .to raise_error
    end
  end
end
