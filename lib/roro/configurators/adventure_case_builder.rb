# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder
      include Utilities

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
      end

      def build_cases(stack, cases = nil )
        cases ||= []
        if stack_type(stack).eql?(:inflection)

        end
        children(stack).each do |child|
          build_cases(child, cases)

        end
        cases

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
