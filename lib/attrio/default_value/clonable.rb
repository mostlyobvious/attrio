# frozen_string_literal: true

module Attrio
  module DefaultValue
    class Clonable < Base
      SINGLETON_CLASSES = [
        ::NilClass,
        ::TrueClass,
        ::FalseClass,
        ::Numeric,
        ::Symbol
      ].freeze

      def self.handle?(value)
        case value
        when *SINGLETON_CLASSES
          false
        else
          true
        end
      end

      # Evaluates the value via value#clone
      #
      # @return [Object] evaluated value
      #
      def call(*)
        @value.clone
      end
    end
  end
end
