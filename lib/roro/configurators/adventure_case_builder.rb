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

        def build_cases(catalog = nil, cases = nil, parent = nil)
          cases ||= @cases
          catalog ||= @catalog
          case
          when catalog_is_empty?(catalog)
            return
          when catalog_is_template?(catalog)
            return
          when catalog_is_node?(catalog)
            parent = name(catalog)
            cases[parent] = {  }
            get_children(catalog).each do |child|
              build_cases(child, cases, parent)
            end
          when catalog_is_inflection?(catalog)
            question_builder = QuestionBuilder.new(inflection: catalog)
            inflection_options = question_builder.inflection_options
            cases[parent] = {}
            inflection_options.each do |_key, value|
              cases[parent][value] = build_cases("#{catalog}/#{value}", cases, value)
            end
          #   choice = choose_adventure(catalog)
          #   build_cases("#{catalog}/#{choice}")
          end
          @cases = cases
        end
      end
    end
  end
end
