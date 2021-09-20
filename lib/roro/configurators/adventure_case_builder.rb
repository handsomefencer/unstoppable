# frozen_string_literal: true

require 'iteraptor'
require 'ocg'

module Roro
  module Configurators
    class AdventureCaseBuilder < Thor
      include Thor::Actions

      attr_reader :cases

      no_commands do
        def build(catalog=nil)
          @catalog = catalog || Roro::CLI.catalog_root
          @itinerary = []
          @cases = {}
          build_cases
        end

        def build_paths(catalog, story_paths = nil)
          story_paths ||= []
          story_paths << catalog if catalog_is_story_path?(catalog)
          get_children(catalog).each { |c| build_paths(c, story_paths) }
          story_paths
        end

        def build_itineraries(catalog, itinerary = nil, itineraries = nil)
          itineraries ||= []
          case
          when catalog_is_story_path?(catalog)
            itinerary   ||= []
            itinerary << catalog
          when catalog_is_inflection?(catalog)
            get_children(catalog).each do |child|
              build_itineraries(child, itinerary, itineraries)
            end
            itineraries
          end
          children = get_children(catalog)
          children.each do |child|
            build_itineraries(child, itinerary, itineraries)
          end
          if itinerary&.empty?
            itineraries
          else
            itineraries << itinerary
          end
          itineraries
        end

        def build_cases(catalog = nil, paths = nil, parent = nil)
          parent  ||= catalog
          catalog ||= @catalog
          paths   ||= {}
          @cases  ||= []
          case
          when catalog_is_empty?(catalog)
            return
          when catalog.nil?
            return
          when catalog_is_file?(catalog)
            return
          when catalog_is_node?(catalog)
            get_children(catalog).each do |child|
              build_cases(child, paths, parent)
            end
          when catalog_is_inflection?(catalog)
            @inflections = all_inflections(parent)
            question_builder = QuestionBuilder.new(inflection: catalog)
            inflection_options = question_builder.inflection_options
            parent = catalog_parent_path(catalog)
            paths[name(catalog)] = {}
            inflection_options.each do |key, value|
              inflection_path = "#{catalog}/#{value}"
              paths[name(catalog)][value] = build_cases(inflection_path, {}, parent)
              unless catalog_has_inflections?(inflection_path)
                inflection_paths ||= []
                inflection_paths << inflection_path
                @cases << inflection_paths
              end
            end
          end
          paths
          @cases
        end

        def all_inflections(catalog)
          inflections ||= []
          get_children(catalog).each do |child|
            inflections << child if catalog_is_inflection?(child)
          end
          inflections
        end

        def catalog_is_story_path?(catalog)
          !catalog_has_inflections?(catalog) &&
            !catalog_is_template?(catalog) &&
            catalog_is_node?(catalog)
        end

        def catalog_has_inflections?(catalog)
          get_children(catalog).any? { |child| catalog_is_inflection?(child) }
        end
      end
    end
  end
end
