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

        def build_cases(catalog = @catalog, cases = nil)
          cases ||= { name(catalog) => {}}
          if catalog_is_node?(catalog)
            get_children(catalog).each { |child| build_cases(child, cases) }
          elsif catalog_is_inflection?(catalog)
            question = QuestionBuilder.new(inflection: catalog)
            cases[name(catalog)] ||= []
            question.inflection_options.values.each do |story|
              cases[name(catalog)] << { story => build_cases("#{catalog}/#{story}") }
            end
          end
          cases
        end

        def build_itineraries(cases, itinerary = nil )
          itineraries ||= []
          itinerary ||= []
          if cases.is_a?(Hash)
            itineraries
          end
          # case
          # when cases.is_a?(Hash)
          #   itineraries
          #   'blah'# each do |item|
          # when cases.is_a?(Array)
          #   itineraries
          #   cases.each do |item|
          #     item
          #   end
          # end
          # itineraries
        end
      end
    end
  end
end
