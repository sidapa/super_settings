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

  context '.method_missing' do
    it 'should call a registered operator if no method was found'
  end

  context '.register' do
    let(:registered_operator) { { klass: 'test', method: 'only' } }

    it 'should allow an operator to be registered' do
      SuperSettings::Calculate.register(:lookup_key, registered_operator)

      lookup_result = SuperSettings::Calculate
                      .instance_variable_get('@operators')[:lookup_key]
      expect(lookup_result).to eql(registered_operator)
    end

    it 'should fail if operator has been registered'
  end
end
