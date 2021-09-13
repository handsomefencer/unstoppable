# frozen_string_literal: true

require_relative 'validations'
require_relative 'utilities'

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions

      attr_reader :itinerary

      no_commands do
        def initialize(catalog=nil)
          @catalog = catalog || Roro::CLI.catalog_root
          @itinerary = []
          build_itinerary
        end

        def build_itinerary(catalog=nil)
          catalog ||= @catalog
          case
          when catalog_is_empty?(catalog)
            return
          when catalog_is_node?(catalog)
            @itinerary += catalog_stories(catalog)
            get_children(catalog).each do |child|
              build_itinerary(child)
            end
          when catalog_is_inflection?(catalog)
            choice = choose_adventure(catalog)
            build_itinerary("#{catalog}/#{choice}")
          end
        end

        def catalog_stories(catalog)
          Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
        end

        def choose_adventure(inflection)
          builder = QuestionBuilder.new(inflection: inflection)
          question = builder.question
          builder.answer_from(ask(question))
        end
      end
    end
  end
end
