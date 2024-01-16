# frozen_string_literal: true

# encoding: utf-8

module Attrio
  module Types
    class Date < Base
      def self.typecast(value, options = {})
        begin
          if options[:format].present?
            ::Date.strptime(value.to_s, options[:format])
          else
            ::Date.parse(value.to_s)
          end
        rescue ArgumentError => e
          nil
        end
      end

      def self.typecasted?(value, options = {})
        value.is_a? ::Date
      end
    end
  end
end
