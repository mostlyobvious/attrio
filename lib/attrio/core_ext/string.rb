# frozen_string_literal: true

# encoding: utf-8

class String # :nodoc:
  unless method_defined?(:underscore)
    def underscore
      self
        .gsub(/::/, "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end
  end

  unless method_defined?(:camelize)
    def camelize
      self.split(/[^a-z0-9]/i).map { |w| w.capitalize }.join
    end
  end
end
