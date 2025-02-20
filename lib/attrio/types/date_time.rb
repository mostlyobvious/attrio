# frozen_string_literal: true

module Attrio
  module Types
    class DateTime < Base
      def self.typecast(value, options = {})
        begin
          if options[:format].present?
            ::DateTime.strptime(value.to_s, options[:format])
          else
            ::DateTime.parse(value.to_s)
          end
        rescue ArgumentError => e
          nil
        end
      end

      def self.typecasted?(value, options = {})
        value.is_a? ::DateTime
      end
    end
  end
end
