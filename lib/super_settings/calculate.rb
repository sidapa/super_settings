module SuperSettings
  # The Calculate class allows a user to define operators.
  # These registrators are registered into the class and are
  # accessible via method_missing lookup
  class Calculate
    @operators = {}

    class << self
      def register(operator, receiver)
        @operators[operator] = receiver
      end
    end
  end
end
