module SuperSettings
  # The SuperSettings::AutoCallable module allows an object mixing this module
  # in to override the method_missing. To use AutoCallable, your class needs
  # to implement the following methods: value_hash (for identifying the hash
  # which holds value information) and process_value (which gets called after
  # the value is extracted from the value_hash and, by default, merely returns
  # the value from the hash)
  module AutoCallable
    # value_hash provides an AutoCallable object with a target key-value pair to check
    # method missing against. This template needs to be implemented by a class
    # mixing in the AutoCallable module.
    def value_hash
      fail NotImplementedError, 'value_hash required by SuperSettings::AutoCallable'
    end

    # By default, AutoCallable will return the value in the value_hash
    # override this method if you wish to have a different sort of
    # funtionality
    # TODO: check for block given, and yield to block passing
    # value as parameter
    def process_value(value, *args, &block)
      value
    end

    def method_missing(method_sym, *args, &block)
      super unless value_hash.keys.include? method_sym

      # TODO: class_eval a new method to skip method missing for next calls
      # - Research whether or not torquebox will suffer

      process_value(value_hash[method_sym], *args, &block)
    end
  end
end
