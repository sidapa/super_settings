require 'ostruct'

module SuperSettings
  # This class handles SuperSettings Configuration. This is basically
  # an OpenStruct class with an additional external method.
  class Config < OpenStruct
    # fetch! returns the value of they key if it exists. If it does not,
    # it then either yields to a block if given, or throws an exception.
    def fetch!(param, &_block)
      return self[param] if method_exists param
      return yield if block_given?

      fail SuperSettings::Error, "#{param} does not exist"
    end

    private

    # @table is used by OpenStruct to store the hash. This method uses
    # table keys to check if it knows about a key rather then using
    # respond_to?
    def method_exists(name)
      @table.keys.include? name.to_sym
    end
  end
end
