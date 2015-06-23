require 'spec_helper'

describe SuperSettings::FeatureSetLoaders::RedisLoader do
  describe '::call' do
    subject(:call_method) do
      SuperSettings::FeatureSetLoaders::RedisLoader.call(configuration)
    end

    let(:configuration) do
      SuperSettings::Config.new(datastore_type: :redis,
                                host: 'localhost',
                                port: 3386,
                                db: 1,
                                hash_name: 'test')
    end

    # TODO: Redis allows url config
    context 'complete data' do
      let(:redis_double) { double(load: true) }

      before(:each) do
        allow(SuperSettings::Datastores::Redis).to receive(:new)
          .and_return(redis_double)
        call_method
      end

      it { expect(configuration.respond_to? :datastore).to eql(true) }
      it { expect(configuration.datastore).to eql(redis_double) }
      it { expect(call_method).to eql(true) }
    end

    context 'not configured' do
      let(:configuration) do
        SuperSettings::Config.new(datastore_type: :not_yaml)
      end

      it { expect(call_method).to eql(false) }
    end

    context 'invalid parameters' do
      let(:configuration) { SuperSettings::Config.new(datastore_type: :redis) }

      it { expect { call_method }.to raise_error SuperSettings::Error }

      context 'missing hash_name' do
        let(:configuration) do
          SuperSettings::Config.new(datastore_type: :redis,
                                    host: 'localhost',
                                    port: 3386,
                                    db: 1)
        end

        it { expect { call_method }.to raise_error SuperSettings::Error }
      end
    end
  end
end
