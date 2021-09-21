# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder < Thor
      include Thor::Actions

      attr_reader :cases, :itineraries

      no_commands do
        def build(catalog=nil)
          @catalog = catalog || Roro::CLI.catalog_root
          @itinerary = []
          @cases = {}
          build_itineraries(catalog)
        end

        def build_paths(catalog, story_paths = nil)
          story_paths ||= []
          story_paths << catalog if catalog_is_story_path?(catalog)
          get_children(catalog).each { |c| build_paths(c, story_paths) }
          story_paths
        end

        def build_itineraries(catalog)
          @itineraries ||= []
          @itineraries += build_itinerary(catalog)
          get_children(catalog).each { |c| build_itineraries(c) }
          @itineraries
        end

        def build_itinerary(catalog)
          @itinerary = []
          all_inflections(catalog).each do |inflection|
            paths = story_paths(inflection).map { |p| [p] }
            @itinerary = @itinerary.empty? ? paths : @itinerary.product(paths)
          end
          @itinerary.map(&:flatten)
        end

        def catalog_is_parent?(catalog)
          get_children(catalog).any? { |c| catalog_is_inflection?(c) }
        end

        def all_inflections(catalog)
          get_children(catalog).select { |c| catalog_is_inflection?(c) }
        end

        def story_paths(catalog)
          get_children(catalog).select { |c| catalog_is_story_path?(c) }
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
