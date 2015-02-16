require 'spec_helper'

describe SuperSettings::Calculate do
  context '.method_missing' do
    it 'should call a registered operator if no method was found'
  end
  context '.register' do
    it 'should allow an operator to be registered'
  end
end
