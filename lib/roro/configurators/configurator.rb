# frozen_string_literal: true
require 'byebug'
require 'yaml'

module Roro
  module Configurators
    class Configurator

      include Utilities

      attr_reader :structure, :itinerary, :manifest, :stack, :env

      def initialize(options = {})
        @options   = options ? options : {}
        @stack     = options[:stack] || CatalogBuilder.build
        @validator = Validator.new(@stack)
        @adventure = AdventureChooser.new
        @builder   = QuestionBuilder.new
        @structure = StructureBuilder.build
        @asker     = QuestionAsker.new
        @writer    = AdventureWriter.new
        @env       = @structure[:env]
      end

      def rollon
        validate_stack
        choose_adventure
        satisfy_dependencies
        build_env
        write_story
        structure[:env] = structure[:env].merge(@dependency_hash)
      end

      def validate_stack
        @validator.validate(@stack)
      end

      def choose_adventure
        @adventure.build_itinerary(@stack)
        @itinerary = @adventure.itinerary
        @manifest  = @adventure.manifest
      end

      def build_env
        manifest.each { |story| accrete_story(story) }
        override_environment_variables
      end

      def satisfy_dependencies
        @satisfier = DependencySatisfier.new
        @dependency_hash = @satisfier.satisfy_dependencies(manifest)
      end

      def accrete_story(story)
        content = read_yaml(story)[:env]
        content.keys.each { |k| @structure[:env][k].merge!(content[k]) } if content
      end

      def override_environment_variables
        @structure[:env].each do |e, h| h.each do |k, v|
            answer = @asker.confirm_default(@builder.override(e, k, v), h)
            answer.eql?('') ? return : v[:value] = answer
          end
        end
      end

      def write_story
        @manifest.sort.each { |m| @writer.write(@structure, m) }
      end
    end
  end
end
