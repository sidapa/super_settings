require 'spec_helper'

describe SuperSettings::FeatureSet do
  describe '::config' do
    subject(:configuration) { SuperSettings::FeatureSet.configuration }

    before(:each) do
      SuperSettings::FeatureSet.config do |config|
        config.foo = :bar
      end
    end

    it { expect(configuration.foo).to eql(:bar) }
  end
end
