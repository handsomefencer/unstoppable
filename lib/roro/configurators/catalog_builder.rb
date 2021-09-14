# frozen_string_literal: true

require_relative 'validations'

module Roro
  module Configurators
    class CatalogBuilder
      attr_reader :structure

      def self.build(override=nil)
        override || self.base
      end

      def self.base
        Roro::CLI.catalog_root
      end
    end
  end
end
