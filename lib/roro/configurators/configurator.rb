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
        satisfy_dependencies
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

      def satisfy_dependencies
        @dependencies ||= {}
        manifest.each do |story|
          content = read_yaml(story)[:depends_on] || {}
          @dependencies.merge!(content) unless content.nil?
        end
        @dependencies.each { |d| satisfy_dependency(d) }
      end

      def dependency_installed?(command)
        result = `command -v #{command} &> /dev/null`
        result.match?(command)
      end

      def satisfy_dependency(*dependency)
        dependency.each do |key, value|
          installable = key.to_s
          return if dependency_installed?(installable)
          msg = [ "\nDependency '#{installable}' is not installed." ]
          msg << "Install instructions: #{value[:help]}" if value&.dig(:help)
          msg << "Verify install: #{value[:command]}" if value&.dig(:command)
          raise Roro::Error, msg.join("\n")
        end
      end

      def accrete_story(story)
        content = read_yaml(story)[:env]
        content.keys.each { |k| @env[k].merge!(content[k]) } if content
      end

      def override_environment_variables
        @env.each do |e, h| h.each do |k, v|
            answer = @asker.confirm_default(@builder.override(e, k, v), h)
            answer.eql?('') ? return : v[:value] = answer
          end
        end
      end

      def write_story
        @manifest.sort.each { |m| @writer.write(@env, m) }
      end
    end

    def installed?(installable)
      result = `command -v #{installable} &> /dev/null`
      result.match?(installable)
    end
  end
end
