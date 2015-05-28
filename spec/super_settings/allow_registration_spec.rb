require 'spec_helper'

describe SuperSettings::AllowRegistration do
  subject(:allow_module) { SuperSettings::AllowRegistration }

  let(:extending_class) do
    Class.new { extend SuperSettings::AllowRegistration }
  end

  describe '#value_hash' do
    subject(:value_hash_method) { extending_class.value_hash }

    it { expect { value_hash_method }.to raise_error NotImplementedError }
  end

  describe '#validate_value' do
    subject(:validate_value_method) { extending_class.validate_value(1) }

    it { expect { validate_value_method }.to raise_error NotImplementedError }
  end
end
