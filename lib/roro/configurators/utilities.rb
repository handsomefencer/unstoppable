# frozen_string_literal: true

module Roro
  module Configurators
    module Utilities

      def sanitize(hash)
        (hash ||= {}).transform_keys!(&:to_sym).each do |key, value|
          case value
          when Array
            value.each { |vs| sanitize(vs) }
          when Hash
            sanitize(value)
          when true
            hash[key] = true
          when String || Symbol
            hash[key] = value.to_sym
          end
        end
      end

      def sentence_from(array)
        array[1] ? "#{array[0..-2].join(', ')} and #{array[-1]}" : array[0]
      end
    end
  end
end
