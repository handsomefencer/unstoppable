# frozen_string_literal: true

require 'yaml'

module Roro
  module Configurators
    class Configurator
      include Utilities

      attr_reader :structure, :itinerary, :manifest, :stack, :env

      def initialize(options = {})
        @options    = options || {}
        @stack      = options[:stack] || CatalogBuilder.build
        @validator  = Validator.new(@stack)
        @reflection = StackReflector.new(@stack)
        @chooser    = AdventureChooser.new
        @builder    = QuestionBuilder.new
        @structure  = StructureBuilder.build
        @asker      = QuestionAsker.new
        @writer     = AdventureWriter.new
        @env        = @structure[:env]
      end

      def rollon
        validate_stack
        choose_adventure
        build_env
        write_story
      end

      def validate_stack
        validator = Validator.new(@stack)
        validator.validate(@stack)
      end

      def choose_adventure
        answers = @chooser.record_answers
        reflection = Roro::Configurators::StackReflector.new
        adventure = reflection.adventure_for(answers.map(&:to_i))
        @manifest = adventure[:chapters]
      end

      def build_env
        manifest.each do |story|
          accrete_story(story)
        end
        override_environment_variables
      end

      def accrete_story(story)
        content = read_yaml(story)[:env]
        content.keys.each { |k| @structure[:env][k].merge!(content[k]) } if content
      end

      def override_environment_variables
        @structure[:env].each do |e, h|
          h.each do |k, v|
            answer = @asker.confirm_default(@builder.override(e, k, v), h)
            answer.eql?('') ? return : v[:value] = answer
          end
        end
      end

      def write_story
        @manifest.each do |m|
          @structure[:itinerary] = @itinerary
          @writer.write(@structure, m)
        end
      end
    end
  end
end
