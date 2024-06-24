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
          dependencies: {},
          depends_on: [''],
          env: {
            base: {},
            ci: {},
            development: {},
            staging: {},
            test: {},
            production: {}
          },
          preface: '',
          questions: [
            {
              question: '',
              help: '',
              action: ''
            }
          ],
          success: ''
        }
      end
    end
  end
end
