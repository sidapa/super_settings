require 'spec_helper'

describe SuperSettings::AllowMethodMissingOverride do
  subject(:allow_module) { SuperSettings::AllowMethodMissingOverride }

  let(:extending_class) do
    Class.new { extend SuperSettings::AllowMethodMissingOverride }
  end

  describe '#value_data' do
    subject(:value_data_method) { extending_class.value_data }

    context 'where @value_data is not set' do
      it { is_expected.to eql({}) }
    end

    context 'where @value_data is set' do
      before(:each) do
        extending_class.instance_variable_set(:@value_data, vh_value)
      end

      let(:vh_value) { { foo: 'bar' } }

      it { is_expected.to eql(vh_value) }
    end
  end

  describe '#validate_value' do
    context 'when not overidden' do
      subject(:validate_value_method) { extending_class.process_value(1) }

      it { is_expected.to eql(1) }
    end

    context 'when block is given' do
      subject(:validate_value_method) do
        extending_class.process_value(1) do
          return 5
        end
      end

      it { is_expected.to eql(5) }
    end
  end

  describe '#respond_to_method_missing' do
    subject(:respond_method) { extending_class }

    before(:each) do
      allow(extending_class)
        .to receive(:value_data)
        .and_return(foo: 'bar')
    end

    context 'method in value_data' do
      let(:key) { :not_foo }

      it { is_expected.not_to respond_to key }
    end

    context 'method in value_data' do
      let(:key) { :foo }

      it { is_expected.to respond_to key }
    end
  end
end
