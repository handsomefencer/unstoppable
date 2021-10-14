# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
      end

      def build_cases(stack, cases = [], array = [], position = 0 )
        @base ||= stack

        children(stack).each_with_index do |child, index|
          if stack_type(stack).eql?(:inflection)
            choice = "#{child.split(@base).last}"
            next unless [:stack, :story].include?(stack_type(child))
            case
            when children(stack).last.eql?(child)
              array = array.take(position)
              array << choice
              cases << array
            when array.size.eql?(position)
              array << choice
            when array.size.eql?(position + 1)
              cases << array
              array = array.take(position)
              array << choice
            # when array.size.eql?(position - 1)
            #   array = array.take(position)
            when array.size.eql?(position + 2)
              array = array.take(position)
            else
              cases << array
              # array = array.take(position)
            end
            # position += 1
          end
          build_cases( child, cases, array, (position - index) + 1)
        end
        cases.uniq.sort
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
