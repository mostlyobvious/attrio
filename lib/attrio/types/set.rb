# frozen_string_literal: true

module Attrio
  module Types
    class Set < Array
      def self.typecast(value, options = {})
        begin
          set =
            (
              if value.respond_to?(:split)
                value.split(options[:split]).to_set
              else
                Attrio::Helpers.to_a(value).to_set
              end
            )

          if options[:element].present?
            type =
              Attrio::AttributesParser.cast_type(
                self.element_type(options[:element])
              )
            options = self.element_options(options[:element])

            set.map! do |item|
              if type.respond_to?(:typecast) && type.respond_to?(:typecasted?)
                type.typecasted?(item) ? item : type.typecast(item, options)
              else
                type == Hash && item.is_a?(Hash) ? value : type.new(item)
              end
            end
          end

          set
        rescue ArgumentError => e
          nil
        end
      end

      def self.typecasted?(value, options = {})
        value.is_a? ::Set
      end
    end
  end
end
