# frozen_string_literal: true

require_relative 'validations'

module Roro
  module Configurators
    class Structurer < Thor
      attr_reader :structure, :story

      def initialize(override_location = nil)
        build_story
      end

      def build_story
        @story = {
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
