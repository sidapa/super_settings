module SuperSettings
  # The SuperSettings::AutoCallable module allows an object mixing this module
  # in to override the method_missing. To use AutoCallable, your class needs
  # to implement the following methods: value_hash (for identifying the hash
  # which holds value information) and process_value (which gets called after
  # the value is extracted from the value_hash and, by default, merely returns
  # the value from the hash)
  module AllowMethodMissingOverride
    # value_hash provides an AutoCallable object with a target key-value pair
    # to check method missing against. This template needs to be implemented
    # by a class mixing in the AutoCallable module.
    def value_hash
      @value_hash ||= {}
    end

    # By default, AutoCallable will return the value in the value_hash
    # override this method if you wish to have a different sort of
    # funtionality
    def process_value(value)
      block_given? ? yield(value) : value
    end

    # TODO: class_eval a new method to skip method missing for next calls
    # - Research whether or not torquebox will suffer
    def method_missing(method_sym, *args, &block)
      super unless value_hash.keys.include? method_sym

      process_value(value_hash[method_sym], *args, &block)
    end

    def respond_to_missing?(method, *)
      value_hash.keys.include?(method) || super
    end
  end
end
