# frozen_string_literal: true

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
        @log       = @structure
      end

      def rollon
        validate_stack
        choose_adventure
        # satisfy_dependencies
        build_env
        write_story
        # structure[:env] = structure[:env].merge(@dependency_hash)
        write_log
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
        manifest.each do |story|
          accrete_story(story)
        end
        override_environment_variables
      end

      # def satisfy_dependencies
      #   @satisfier = DependencySatisfier.new
      #   @dependency_hash = @satisfier.satisfy_dependencies(manifest)
      # end

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

      def copy_stage_dummy(stage)
        location = Dir.pwd
        stage_dummy = "#{stack_parent_path(stage)}/test/stage_one/stage_dummy"
        generated = Dir.glob("#{location}/**/*")
        dummies = Dir.glob("#{stage_dummy}/**/*")
        stage_dummy_index(stage)
        dummies.each do |dummy|
          generated.select do |g|
            if dummy.split(stage_dummy).last.match?(g.split(Dir.pwd).last)
              FileUtils.cp(g, "#{stage_dummy}/#{name(g)}")
            end
          end
        end
      end

      def write_story
        @manifest.each do |m|
          @writer.write(@structure, m)
          copy_stage_dummy(m)
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
