require 'spec_helper'

describe SuperSettings::AllowRegistration do
  subject(:allow_module) { SuperSettings::AllowRegistration }

  let(:extending_class) do
    Class.new { extend SuperSettings::AllowRegistration }
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

  describe '#validate_value_with' do
    context 'sent a non-array/non-symbol' do
    end

    context 'sent a symbol' do
      before(:each) { extending_class.validate_value_with(:test) }

      subject(:validators_list) do
        extending_class.instance_variable_get(:@validators_list)
      end

      it { is_expected.to be_kind_of Array }
      it { is_expected.to eql([:test]) }
    end

    context 'sent an array' do
      before(:each) { extending_class.validate_value_with([:test, :test2]) }

      subject(:validators_list) do
        extending_class.instance_variable_get(:@validators_list)
      end

      it { is_expected.to be_kind_of Array }
      it { is_expected.to eql([:test, :test2]) }
    end

    context 'sent invalid values' do
      subject(:validate_method) do
        extending_class.validate_value_with(value_methods)
      end

      let(:value_methods) { [:test, :test2] }

      context 'sent a non symbol' do
        let(:value_methods) { [1] }
        it { expect { validate_method }.to raise_error SuperSettings::Error }
      end

      context 'sent an already defined value' do
        let(:value_methods) { [:test] }
        it 'raises an error' do
          extending_class.validate_value_with(:test)

          expect { validate_method }.to raise_error SuperSettings::Error
        end
      end
    end
  end

  describe '#run_validations' do
    let(:extending_class) do
      Class.new do
        extend SuperSettings::AllowRegistration
      end
    end

    let(:test_methods) { [:foo, :bar] }

    context '@validators_list is invalid' do
      before(:each) do
        extending_class.instance_variable_set(:@validators_list, list)
      end

      let(:list) { [:foo] }

      subject(:run_validations) { extending_class.run_validations(1) }

      context '@validators_list is nil' do
        let(:list) { nil }
        it { expect { run_validations }.not_to raise_error }
      end

      context '@validators_list is empty' do
        let(:list) { [] }
        it { expect { run_validations }.not_to raise_error }
      end
    end

    it 'calls methods in the validators_list' do
      extending_class.instance_variable_set(:@validators_list, test_methods)

      test_methods.each do |m|
        expect(extending_class).to receive(m).with(1)
      end

      extending_class.run_validations(1)
    end
  end

  describe '::reset!' do
    let(:vh_value) { 1 }
    subject(:reset_method) { extending_class.reset! }

    before(:each) do
      extending_class.instance_variable_set(:@value_data, vh_value)
    end

    it 'resets @value_data to an empty hash' do
      expect { reset_method }.to change {
        extending_class.instance_variable_get :@value_data
      }.to({})
    end
  end
end
