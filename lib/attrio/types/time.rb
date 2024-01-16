# frozen_string_literal: true

# encoding: utf-8

module Attrio
  module Types
    class Time < Base
      def self.typecast(value, options = {})
        begin
          if options[:format].present?
            ::Time.strptime(value.to_s, options[:format])
          else
            ::Time.parse(value.to_s)
          end
        rescue ArgumentError => e
          nil
        end
      end

      def self.typecasted?(value, options = {})
        value.is_a? ::Time
      end
    end
  end
end
