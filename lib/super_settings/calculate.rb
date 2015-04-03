module SuperSettings
  # The Calculate class allows a user to define operators.
  # These registrators are registered into the class and are
  # accessible via method_missing lookup
  class Calculate
    @operators = {}

    class << self
      def register(operator, receiver)
        fail if @operators.keys.include? operator

        @operators[operator] = receiver
      end

      def method_missing(method_sym, *args, &block)
        super unless @operators.keys.include? method_sym

        # TODO: class_eval a new method to skip method missing for next calls

        result_hash = @operators[method_sym]
        result_hash[:klass]
          .send(result_hash[:method], *args, &block)
      end
    end
  end
end
