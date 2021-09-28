# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def build(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
        build_itineraries(catalog)
      end

      def build_itineraries(catalog)
        @itineraries ||= []
        @itineraries += build_itinerary(catalog)
        children(catalog).each { |c| build_itineraries(c) }
        @itineraries
      end

      private

      def build_itinerary(catalog)
        itinerary = []
        all_inflections(catalog).each do |inflection|
          paths = story_paths(inflection).map { |p| [p] }
          itinerary = itinerary.empty? ? paths : itinerary.product(paths)
        end
        itinerary.map(&:flatten)
      end
    end
  end
end
