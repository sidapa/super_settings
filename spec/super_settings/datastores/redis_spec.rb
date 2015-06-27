require 'spec_helper'

describe SuperSettings::Datastores::Redis do
  subject(:redis) { SuperSettings::Datastores::Redis.new(config) }
  let(:config) do
    SuperSettings::Config.new(datastore_type: :redis,
                              host: 'localhost',
                              port: 80,
                              db: 15,
                              hash_name: 'test')
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

    before(:each) do
      allow(Redis).to receive(:new).with(redis_config)
        .and_return(redis_double)

      allow(redis_double).to receive(:hkeys)
        .and_return(['redis_feature'])

      allow(redis_double).to receive(:hget)
        .and_return({ foo: 'bar' }.to_json)

      SuperSettings::FeatureSet.reset!
    end

    let(:redis_double) { double }

    let(:redis_config) do
      { host: 'localhost',
        port: 80,
        db: 15 }
    end

    it { is_expected.to eql(true) }

    context 'with valid connection' do
      let(:feature_set) do
        SuperSettings::FeatureSet
      end

      it 'clears the feature sets' do
        expect(SuperSettings::FeatureSet).to receive(:reset!)

        load_method
      end

      it { expect(load_method).to eql(true) }

      it 'allows FeatureSet to respond_to redis_feature' do
        load_method
        expect(feature_set.respond_to? :redis_feature).to eql(true)
      end
    end
  end
end
