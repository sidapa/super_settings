require 'spec_helper'

describe SuperSettings::Feature do
  subject(:feature) { SuperSettings::Feature.new(toggle) }
  let(:toggle) { true }

  context '.initialize' do
    subject(:new_feature) { SuperSettings::Feature.new(toggle) }
    context 'given an invalue value' do
      let(:toggle) { 1 }

      it { expect { new_feature }.to raise_error SuperSettings::Error }
    end

    context 'given a boolean value' do
      it { expect { new_feature }.not_to raise_error }
      it { expect(new_feature.instance_variable_get(:@value)).to eql(toggle) }
    end

    context 'given a context hash' do
      let(:toggle) { { default: true, foo: 'bar' } }

      it { expect { new_feature }.not_to raise_error }
      it { expect(new_feature.instance_variable_get(:@value)).to eql(toggle) }

      context "with no 'default' key" do
        let(:toggle) { { foo: 'bar' } }

        it { expect { new_feature }.to raise_error SuperSettings::Error }
      end

      context "with no 'default' value not boolean" do
        let(:toggle) { { default: 1, foo: 'bar' } }

        it { expect { new_feature }.to raise_error SuperSettings::Error }
      end
    end
  end

  context '#set?' do
    subject(:feature_set) { SuperSettings::Feature.new(toggle).set?(context) }
    let(:context) { nil }

    context '@value is true' do
      let(:toggle) { true }
      it { is_expected.to eql(toggle) }
    end

    context '@value is false' do
      let(:toggle) { false }
      it { is_expected.to eql(toggle) }
    end

    context 'context is neither boolean nor a hash' do
      let(:context) { 1 }

      it { is_expected.to eql(false) }
    end

    context 'context is a hash' do
      let(:toggle) { { default: default_value, foo: 'bar' } }
      let(:default_value) { true }

      context 'context key is unknown' do
        let(:context) {  { not_foo: 'bar' } }

        it { is_expected.to eql(default_value) }
      end

      context 'context key matches toggle' do
        let(:context) { { foo: 'bar' } }

        it { is_expected.to eql(true) }
      end
    end
  end
end
