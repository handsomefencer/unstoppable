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
        @adventure  = AdventureChooser.new
        @chooser    = AdventureChooser.new
        @builder    = QuestionBuilder.new
        @structure  = StructureBuilder.build
        @asker      = QuestionAsker.new
        @writer     = AdventureWriter.new
        @env        = @structure[:env]
        @log        = @structure
      end

      def rollon
        validate_stack
        choose_adventure
        build_env
        write_story
        write_log
      end

      def validate_stack
        @validator.validate(@stack)
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

      def itinerary_index(stage)
        itineraries = read_yaml("#{Roro.gem_root}/test/fixtures/matrixes/itineraries.yml")
        itineraries.select! do |i|
          i.include?(stack_parent_path(stage.split(Roro::CLI.stacks).last))
        end
      end

      def write_story
        @manifest.each do |m|
          # @structure[:itinerary] = @itinerary
          @writer.write(@structure, m)
        end
      end

      def write_log
        @log[:dependency_hash] = @dependency_hash
        @log[:itinerary]       = @itinerary
        @log[:manifest]        = @manifest
        @log[:stack]           = @stack
        @log[:structure]       = @structure
        @writer.write_log(@log)
      end

      private

      def stage_dummy_index(stack)
        itineraries = read_yaml("#{Roro::CLI.test_root}/fixtures/matrixes/itineraries.yml")
        adventures = itineraries.select! do |i|
          candidate = stack.split(Roro::CLI.stacks).last
          i.include? stack_parent_path(candidate)
        end
        adventures.index(itinerary)
      end
    end
  end
end
