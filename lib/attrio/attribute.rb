# frozen_string_literal: true

# encoding: utf-8

module Attrio
  class Attribute
    attr_reader :name, :type, :options, :object

    def initialize(name, type, options)
      @name = name
      @type = type
      @options = Helpers.symbolize_hash_keys(options)
    end

    def reader_method_name
      @reader_method_name ||=
        self.accessor_name_from_options(:reader) || self.name
    end

    def writer_method_name
      @writer_method_name ||=
        self.accessor_name_from_options(:writer) || "#{self.name}="
    end

    def reader_visibility
      @reader_visibility ||=
        self.accessor_visibility_from_options(:reader) || :public
    end

    def writer_visibility
      @writer_visibility ||=
        self.accessor_visibility_from_options(:writer) || :public
    end

    def instance_variable_name
      @instance_variable_name ||=
        self.options[:instance_variable_name] || "@#{self.name}"
    end

    def default_value
      if !defined?(@default_value)
        @default_value =
          Attrio::DefaultValue.new(self.name, self.options[:default])
      end
      @default_value
    end

    def reset!
      raise ArgumentError if self.object.nil?

      value =
        (
          if self.default_value.is_a?(Attrio::DefaultValue::Base)
            self.default_value.call(self.object)
          else
            self.default_value
          end
        )
      self.object.send(self.writer_method_name, value)
    end

    def default?
      raise ArgumentError if self.object.nil?

      value =
        (
          if self.default_value.is_a?(Attrio::DefaultValue::Base)
            self.default_value.call(self.object)
          else
            self.default_value
          end
        )
      self.object.send(self.reader_method_name) == value
    end

    def define_writer(klass)
      Attrio::Builders::WriterBuilder.define(
        klass,
        self.type,
        self.options.merge(
          {
            method_name: self.writer_method_name,
            method_visibility: self.writer_visibility,
            instance_variable_name: self.instance_variable_name
          }
        )
      )
      self
    end

    def define_reader(klass)
      Attrio::Builders::ReaderBuilder.define(
        klass,
        self.type,
        self.options.merge(
          {
            method_name: self.reader_method_name,
            method_visibility: self.reader_visibility,
            instance_variable_name: self.instance_variable_name
          }
        )
      )
      self
    end

    protected

    def accessor_name_from_options(accessor)
      (
        self.options[accessor.to_sym].is_a?(Hash) &&
          self.options[accessor.to_sym][:name]
      ) || self.options["#{accessor.to_s}_name".to_sym]
    end

    def accessor_visibility_from_options(accessor)
      if self.options[accessor].present? &&
           %i[public protected private].include?(self.options[accessor])
        return self.options[accessor]
      end
      (
        self.options[accessor].is_a?(Hash) &&
          self.options[accessor][:visibility]
      ) || self.options["#{accessor.to_s}_visibility".to_sym]
    end
  end
end
