# frozen_string_literal: true

# encoding: utf-8

class Object
  unless method_defined? :blank?
    def blank?
      !self
    end
  end

  unless method_defined? :present?
    def present?
      !blank?
    end
  end
end
