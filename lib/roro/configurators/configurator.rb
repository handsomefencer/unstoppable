# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator

      attr_reader :structure, :itinerary, :manifest, :actions, :stack, :backstory, :graph

      def initialize(options = {} )
        @options   = options ? options : {}
        @stack     = options[:stack] || CatalogBuilder.build
        @structure = StructureBuilder.build
      end

      def validate_stack
        Validator.new(@stack)
      end

      def choose_adventure
        adventure = AdventureChooser.new
        @itinerary = adventure.build_itinerary(@stack)
      end

      def build_manifest(stack = @stack)
        manifest ||= []
        case stack_type(stack)
        when :story
          manifest += stack_stories(stack)
        when :stack
          manifest += stack_stories(stack)
          children(stack).each { |c| build_manifest(c) }
        when :inflection
        end

        # @manifest += stack_stories(stack)
        # case
        # when itinera
        # end
        # if itinerary.is_a?(Array)
        #   itinerary.each { |i| build_manifest(i) }
        # elsif !trail&.empty?
        #   trail ||= itinerary.split("#{@stack}/").last.split('/')
        #   args = [itinerary, "#{stack}/#{trail.shift}", trail ]
        #   build_manifest(*args)
        # end
        @manifest = manifest.uniq
      end

      def build_graph(manifest = @manifest)
        @graph = @structure
        @graph[:questions].shift
        manifest.each { |story| accrete_story(story) }
      end

      def accrete_story(story)
        content = read_yaml(story)
        accrete_env       content if content[:env]
        accrete_questions content if content[:questions]
      end

      def accrete_env(content)
        env = content[:env]
        env.each do |key, value|
          @graph[:env][key].merge!(content[:env][key])
        end
        # @graph[:questions] += content[:questions] if content[:questions]
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
