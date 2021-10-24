# frozen_string_literal: true

require 'yaml'

module Roro
  module Configurators
    class Configurator
      include Utilities

      attr_reader :structure, :itinerary, :manifest, :stack, :env

      def initialize(options = {} )
        @options   = options ? options : {}
        @stack     = options[:stack] || CatalogBuilder.build
        @validator = Validator.new(@stack)
        @adventure = AdventureChooser.new
        @builder   = QuestionBuilder.new
        @structure = StructureBuilder.build
        @asker     = QuestionAsker.new
        @writer    = AdventureWriter.new
      end

      def rollon
        validate_stack
        choose_adventure
        build_env
        write_story
      end

      def validate_stack
        @validator.validate(@stack)
      end

      def choose_adventure
        @adventure.build_itinerary(@stack)
        @itinerary = @adventure.itinerary
        @manifest = @adventure.manifest
      end

      def build_env
        @env = @structure[:env]
        manifest.each { |story| accrete_story(story) }
        override_environment_variables
      end

      def accrete_story(story)
        content = read_yaml(story)[:env]
        content.keys.each { |k| @env[k].merge!(content[k]) } if content
      end

      def override_environment_variables
        @env.each do |e, v| v.each do |k, v|
            answer = @asker.confirm_default(@builder.override(e, k, v), v)
            answer.eql?('') ? return : v[:value] = answer
          end
        end
      end

      def write_story
        @manifest.sort.each { |m| @writer.write(@env, m) }
      end
    end
  end
end
