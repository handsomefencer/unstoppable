# frozen_string_literal: true

require_relative 'utilities'
require 'yaml'


module Roro
  module Configurators
    include Utilities


    class Configurator
      include Utilities


      attr_reader :structure, :itinerary, :manifest, :stack, :graph

      def initialize(options = {} )
        @options   = options ? options : {}
        @stack     = options[:stack] || CatalogBuilder.build
        @structure = StructureBuilder.build
        @builder   = QuestionBuilder.new
        @asker     = QuestionAsker.new
        @adventure = AdventureChooser.new
        @validator = Validator.new(@stack)
      end

      def rollon
        validate_stack
        choose_adventure
        build_manifest
        build_graph
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

      def build_graph
        @graph = @structure
        manifest.each { |story| accrete_story(story) }
      end

      def accrete_story(story)
        content = read_yaml(story)
        accrete_env(content[:env]) if content[:env]
        override_environment_variables
      end

      def accrete_env(content)
        content.keys.each { |k| @graph[:env][k].merge!(content[k]) }
      end

      def override_environment_variables
        @graph[:env].each do |e, v| v.each do |k, v|
            answer = @asker.confirm_default(@builder.override(e, k, v))
            v[:value] = answer unless answer.eql?('y')
          end
        end
      end

      def write_story
        writer = AdventureWriter.new
        @manifest.each do |storyfile|
          writer.write(@graph[:env], storyfile)
        end
      end
    end
  end
end
