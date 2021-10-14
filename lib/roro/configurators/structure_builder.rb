# frozen_string_literal: true

module Roro
  module Configurators
    class StructureBuilder
      attr_reader :structure

      def self.build(override=nil)
        base.merge(override ||= {})
      end

      def self.base
        @structure = {
          actions: [''],
          env: {
            base: {},
            development: {},
            staging: {},
            production: {}
          },
          preface: '',
          questions: [
            {
              question: '',
              help: '',
              action: ''
            }
          ]
        }
      end
    end
  end
end
