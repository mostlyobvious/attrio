# frozen_string_literal: true

require_relative "attrio/core_ext/object"
require_relative "attrio/core_ext/string"
require_relative "attrio/attributes_parser"
require_relative "attrio/initialize"
require_relative "attrio/inspect"
require_relative "attrio/reset"
require_relative "attrio/helpers"
require_relative "attrio/attribute"
require_relative "attrio/default_value"
require_relative "attrio/builders/accessor_builder"
require_relative "attrio/builders/reader_builder"
require_relative "attrio/builders/writer_builder"
require_relative "attrio/types/base"
require_relative "attrio/types/array"
require_relative "attrio/types/boolean"
require_relative "attrio/types/date"
require_relative "attrio/types/date_time"
require_relative "attrio/types/float"
require_relative "attrio/types/integer"
require_relative "attrio/types/set"
require_relative "attrio/types/symbol"
require_relative "attrio/types/time"

module Attrio
  def self.included(base)
    base.send :include, Attrio::Reset
    base.send :include, Attrio::Inspect

    base.send :extend, Attrio::Initialize
    base.send :extend, Attrio::ClassMethods
  end

  module ClassMethods
    def attrio
      @attrio ||= {}
    end

    def define_attributes(options = {}, &block)
      as = options.delete(:as) || :attributes
      self.attrio[as] = options

      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @#{as} ||= {}

        class << self
          def #{as}(attributes = [])
            attributes = Helpers.to_a(attributes).flatten
            return @#{as} if attributes.empty?

            attributes = @#{as}.keys & attributes
            @#{as}.select{ |k,v| attributes.include?(k) }
          end

          def inherited(subclass)
            subclass.instance_variable_set("@#{as}", instance_variable_get("@#{as}").dup)
          end
        end

        def #{as}(attributes = [])
          # self.class.#{as}(attributes)

          attributes = Helpers.to_a(attributes).flatten
          return @#{as} if attributes.empty?

          attributes = @#{as}.keys & attributes
          @#{as}.select{ |k,v| attributes.include?(k) }
        end
      EOS

      self.define_attrio_reset(as)

      Attrio::AttributesParser.new(self, as, &block)
    end

    def const_missing(name)
      Attrio::AttributesParser.cast_type(name) || super
    end
  end
end
