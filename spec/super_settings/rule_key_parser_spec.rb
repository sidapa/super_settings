require 'spec_helper'

describe SuperSettings::RuleKeyParser do
  describe '.initialize' do
    subject(:parser) { SuperSettings::RuleKeyParser.new(param) }
    let(:param) { :test }

    context 'invalid params' do
      context 'param is not a string, symbol or array' do
        let(:param) { 1 }
        it { expect { parser }.to raise_error(SuperSettings::Error) }
      end

      context 'param is not an array of symbols or strings' do
        let(:param) { [1, :sym] }
        it { expect { parser }.to raise_error(SuperSettings::Error) }
      end
    end
    context 'valid params' do
      subject(:value) { SuperSettings::RuleKeyParser.new(param).value }

      context 'param is a string' do
        let(:param) { 'test' }
        it { is_expected.to eql([:test]) }
      end

      context 'param is an array that includes a string' do
        let(:param) { [:test1, 'test2'] }
        it { is_expected.to eql([:test1, :test2]) }
      end

      context 'param is an array that repeats itself' do
        let(:param) { [:test1, 'test1'] }
        it { is_expected.to eql([:test1]) }
      end
    end
  end
end
