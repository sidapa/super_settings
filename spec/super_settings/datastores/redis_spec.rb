require 'spec_helper'

describe SuperSettings::Datastores::Redis do
  subject(:redis) { SuperSettings::Datastores::Redis.new(config) }
  let(:config) do
    SuperSettings::Config.new(datastore_type: :redis,
                              host: 'localhost',
                              port: 80,
                              db: 15)
  end

  describe '::new' do
    it 'returns a Datastores::Redis instance' do
      expect(redis.class).to eql(SuperSettings::Datastores::Redis)
    end

    context 'complete config' do
      let(:redis_config) do
        { host: 'localhost',
          port: 80,
          db: 15 }
      end

      let(:redis_double) { double }

      it 'creates a new redis server instance' do
        expect(Redis).to receive(:new).with(redis_config)
        redis
      end
    end

    context 'incomplete config' do
      let(:config) do
        SuperSettings::Config.new(datastore_type: :redis)
      end

      it 'throws an error' do
        expect { redis }.to raise_error SuperSettings::Error
      end
    end
  end

  describe '#load' do
    subject(:load_method) { redis.load }

    it { is_expected.to eql(true) }

    context 'with valid connection' do
      before(:each) do
        # Set Redis.load to allow picking up a file
      end

      let(:feature_set) do
        SuperSettings::FeatureSet
      end

      it 'clears the feature sets' do
        expect(SuperSettings::FeatureSet).to receive(:reset!)
        load_method
      end

      it { expect(load_method).to eql(true) }
      it { expect(feature_set.respond_to? :feature_name).to eql(true) }
    end
  end
end
