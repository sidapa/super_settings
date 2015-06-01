module SuperSettings
  # This class allows for feature toggles
  class Feature
    # TODO: Allow user to set a default value when using hashes
    def initialize(value)
      unless [::TrueClass, ::FalseClass, ::Hash].include? value.class
        fail Error, 'Feature requires a boolean or hash'
      end
      @value = value.class == ::Hash ? check_hash_value(value) : value
    end

    def set?(context = nil)
      if context.class == ::Hash
        context.each_pair do |k, v|
          return @value[:default] unless @value.keys.include? k
          return Array(@value[k]).include? v
        end
      elsif !context.nil?
        @value == context
      else
        @value
      end
    end

    private

    def check_hash_value(value)
      value.tap do |v|
        unless v.keys.include? :default
          fail Error, "hash value needs a key ':default'"
        end

        unless [TrueClass, FalseClass].include? v[:default].class
          fail Error, 'default value should be boolean'
        end
      end
    end
  end
end
