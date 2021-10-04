# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator

      attr_reader :structure, :itinerary, :manifest, :actions, :stack, :backstory, :graph

      def initialize(options = {} )
        @options   = options ? options : {}
        @stack     = options[:stack] || CatalogBuilder.build
        @structure = StructureBuilder.build
        @builder   = QuestionBuilder.new
        @asker     = QuestionAsker.new
      end

      def validate_stack
        Validator.new(@stack)
      end

      def choose_adventure
        adventure = AdventureChooser.new
        @itinerary = adventure.build_itinerary(@stack)
      end

      def build_manifest(stack = @stack)
        @manifest ||= []
        case stack_type(stack)
        when :story
          @manifest += stack_stories(stack)
        when :stack
          @manifest += stack_stories(stack)
          children(stack).each { |c| build_manifest(c) }
        when :inflection
        end
      end

      def build_graph
        @graph = @structure
        # @graph[:questions].shift
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

      def accrete_questions(content)
        @graph[:questions] += content[:questions] if content[:questions]
      end

      def build_actions
        @actions ||= []
        manifest.each do |manifest|
          actions = read_yaml(manifest)[:actions]
          @actions += actions if actions
        end
      end
    end
  end
end
