module SuperSettings
  class Calculate
    @operators = {}

    class << self
      def register(operator, receiver)
        @operators[operator] = receiver
      end
    end
  end
end
