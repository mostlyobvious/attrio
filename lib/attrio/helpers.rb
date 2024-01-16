# frozen_string_literal: true

module Attrio
  module Helpers
    extend self

    def to_a(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end

    # note that returning hash without symbolizing anything
    # does not cause this to fail
    def symbolize_hash_keys(hash)
      hash.inject({}) do |new_hash, (key, value)|
        new_hash[
          (
            begin
              key.to_sym
            rescue StandardError
              key
            end
          ) || key
        ] = value
        new_hash
      end
      hash
    end
  end
end
