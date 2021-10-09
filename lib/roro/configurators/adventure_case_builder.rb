# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder
      include Utilities

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
      end

      def build_cases(stack, cases = nil, array = nil )
        @base ||= stack
        cases ||= []
        case stack_type(stack)
        when :inflection
          picker = AdventurePicker.new
          picker.inflection_options(stack).each do |key, value|
            array ||= []
            array << "#{stack.split(@base).last}/#{value}"
            build_cases( "#{stack}/#{value}", cases, array)
          end
        when :stack
          children(stack).each do |child|
            build_cases( child, cases, array)
          end
        when :story
          children(stack).each do |child|
            build_cases( child, cases, array)
          end
        else
          children(stack).each do |child|
            build_cases( child, cases, array)
          end
        end
        cases << array
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
