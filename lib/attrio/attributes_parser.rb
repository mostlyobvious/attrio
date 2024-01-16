# frozen_string_literal: true

# encoding: utf-8

module Attrio
  class AttributesParser
    attr_reader :klass, :as

    def initialize(klass, as, &block)
      @klass = klass
      @as = as

      self.instance_eval(&block)
    end

    def attr(*args)
      attribute_name = args[0].to_s
      attribute_options = (args.last.kind_of?(Hash) ? args.pop : Hash.new)
      attribute_type =
        self.fetch_type(attribute_options.delete(:type) || args[1])

      attribute =
        self.create_attribute(attribute_name, attribute_type, attribute_options)
      self.add_attribute(attribute_name, attribute)

      self
    end

    alias_method :attribute, :attr

    def self.cast_type(constant)
      if constant.is_a?(Class) && !!(constant < Attrio::Types::Base)
        return constant
      end

      string = constant.to_s
      string = string.camelize if (
        string =~ /\w_\w/ || string.chars.first.downcase == string.chars.first
      )

      begin
        if Attrio::Types.const_defined?(string)
          return Attrio::Types.const_get(string)
        elsif Object.const_defined?(string)
          return Object.const_get(string)
        else
          return nil
        end
      rescue StandardError
        return constant
      end
    end

    protected

    # def as
    #   self.options[:as]
    # end

    def fetch_type(name)
      return if name.nil?

      type = self.class.cast_type(name)
      self.class.const_missing(name.to_s) if type.blank?

      type
    end

    def create_attribute(name, type, options)
      Attrio::Attribute
        .new(name, type, options)
        .define_writer(self.klass)
        .define_reader(self.klass)
    end

    def add_attribute(name, attribute)
      @klass.send(self.as)[name.to_sym] = attribute
    end
  end
end
