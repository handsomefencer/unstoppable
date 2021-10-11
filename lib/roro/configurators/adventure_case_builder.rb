# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder
      include Utilities

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
      end

      def build_cases(stack, cases = [], array = [], index = 0 )
        @base ||= stack
        position = array.size
        children(stack).each do |child|
          if stack_type(stack).eql?(:inflection)
            choice = "#{child.split(@base).last}"
            next unless [:stack, :story].include?(stack_type(child))
            if position.eql?(index)
              array << choice
              index += 1
            else
              cases << array.dup
              array.pop(array.size - position)
              array << choice
            end
          end
          build_cases( child, cases, array, index)
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
