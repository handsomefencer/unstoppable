# frozen_string_literal: true

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

        def build_cases(catalog = nil, cases = nil)
          cases ||= {}
          catalog ||= @catalog
          # cases[name(catalog)] ||= {}
          cases ||= {}
          case
          when catalog_is_empty?(catalog)
            return
          when catalog.nil?
            return
          when catalog_is_file?(catalog)
            return
          when catalog_is_node?(catalog)
            get_children(catalog).each do |child|
              build_cases(child, cases)
            end
          when catalog_is_inflection?(catalog)
            question_builder = QuestionBuilder.new(inflection: catalog)
            inflection_options = question_builder.inflection_options
            inflection_options.each do |key, value|
              cases[key] = build_cases("#{catalog}/#{value}")
            end
          end
          cases
        end
      end
    end
  end
end
