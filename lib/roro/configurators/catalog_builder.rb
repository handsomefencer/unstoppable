# frozen_string_literal: true

module Roro
  module Configurators
    class CatalogBuilder
      attr_reader :structure

      def self.build(override=nil)
        override || self.base
      end

      def self.base
        Roro::CLI.stacks
      end
    end
  end
end
