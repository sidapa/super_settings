module SuperSettings
  # The SuperSettings::AutoCallable module allows an object mixing this module
  # in to override the method_missing. To use AutoCallable, your class needs
  # to implement the following methods: value_data (for identifying the hash
  # which holds value information) and process_value (which gets called after
  # the value is extracted from the value_data and, by default, merely returns
  # the value from the hash)
  module AllowMethodMissingOverride
    # value_data provides an AutoCallable object with a target key-value pair
    # to check method missing against. This template needs to be implemented
    # by a class mixing in the AutoCallable module.
    def value_data
      @value_data ||= {}
    end

    # By default, AutoCallable will return the value in the value_data
    # override this method if you wish to have a different sort of
    # funtionality
    def process_value(value)
      block_given? ? yield(value) : value
    end

    # TODO: class_eval a new method to skip method missing for next calls
    # - Research whether or not torquebox will suffer
    def method_missing(method_sym, *args, &block)
      super unless value_data.keys.include? method_sym

      process_value(value_data[method_sym], *args, &block)
    end

    def respond_to_missing?(method, *)
      value_data.keys.include?(method) || super
    end
  end
end
