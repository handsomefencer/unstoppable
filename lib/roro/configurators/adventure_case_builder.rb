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

        def build_itineraries(catalog, story_paths = nil)
          itineraries = []
          if catalog_is_parent?(catalog)
            story_paths ||= []
            all_inflections(catalog).each do |inflection|
              paths = build_paths(inflection).map {|path| [path] }
              if story_paths.empty?
                story_paths = paths
              else
                story_paths = story_paths.product(paths)
              end
              itineraries = story_paths.map { |sp| sp.flatten }
            end
          elsif catalog_is_inflection?(catalog)
            build_paths(catalog)
          end
          itineraries
        end

        def catalog_is_parent?(catalog)
          get_children(catalog).any? { |c| catalog_is_inflection?(c) }
        end

        def all_inflections(catalog)
          get_children(catalog).select { |c| catalog_is_inflection?(c) }
        end

        def catalog_is_story_path?(catalog)
          !catalog_has_inflections?(catalog) &&
            !catalog_is_template?(catalog) &&
            catalog_is_node?(catalog)
        end

        def catalog_has_inflections?(catalog)
          get_children(catalog).any? { |c| catalog_is_inflection?(c) }
        end
      end
    end
  end
end
