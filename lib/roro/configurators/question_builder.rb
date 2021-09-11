# frozen_string_literal: true

require_relative 'validations'
require_relative 'utilities'

module Roro
  module Configurators
    class QuestionBuilder
      include Utilities

      def initialize(args)
        @inflection = args[:inflection]
        build_from_inflection if @inflection
      end

      def build_from_inflection
        prompt = inflection_prompt
        options = inflection_options
        ["#{prompt} #{options}", limited_to: options.keys]
      end

      def inflection_prompt
        prompt = 'Please choose from these'
        tree = @inflection.split('/')
        parent = tree[-2]
        collection = tree.last
        [prompt, parent, collection].join(' ')
      end

      def inflection_options
        Hash.new.tap do |h|
          get_children(@inflection)
            .map { |f| f.split('/').last }
            .sort
            .each_with_index do |c, i|
            h[(i + 1).to_s] = c.split('.').first
          end
        end
      end

      def get_story_preface(story)
        name = story.split('/').last.split('.').first
        read_yaml("#{story}/#{name}.yml")[:preface]
      end



      def catalog_is_node?(catalog)
        get_children(catalog).any? { |w| w.include? '.yml' }
      end

      def catalog_is_story?(catalog)
        %w[yml yaml].include?(story_name(catalog).split('.').last)
      end

      def catalog_is_inflection?(catalog)
        catalog_stories(catalog).empty?
      end

      def catalog_stories(catalog)
        Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
      end

      def node_missing?(node)
        !File.exists?(node)
      end

      def node_empty?(node)
        Dir.glob("#{node}/**").empty?
      end

      def node_is_file?(node)
        File.file?(node)
      end

      def node_exists?(node)

      end

      def story_name(catalog)
        catalog.split('/').last
      end
    end
  end
end
