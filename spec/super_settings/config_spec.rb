require 'spec_helper'

describe SuperSettings::Config do
  subject(:config) { SuperSettings::Config.new(default) }
  let(:default) { { foo: 'bar' } }

  describe '#fetch!' do
    subject(:fetch_method) { config.fetch! fetched_param }
    let(:fetched_param) { :foo }

    context 'with a string' do
      let(:fetched_param) { 'foo' }
      it { is_expected.to eql('bar') }
    end

    context 'with a symbol' do
      let(:fetched_param) { :foo }
      it { is_expected.to eql('bar') }
    end

    context 'with nonexistent symbol' do
      let(:fetched_param) { :baz }
      it { expect { fetch_method }.to raise_error SuperSettings::Error }

      context 'and block given' do
        let(:fetch_method) do
          config.fetch!(fetched_param) do
            5
          end
        end

        it { expect(fetch_method).to eql(5) }
      end
    end
  end
end
