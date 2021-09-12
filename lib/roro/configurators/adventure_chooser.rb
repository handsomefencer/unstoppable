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
          if catalog_is_node?(catalog)
            @itinerary += catalog_stories(catalog)
          end
          if catalog_is_inflection?(catalog)
            return
          end
          get_children(catalog).each do |child|
            build_itinerary(child)
          end
        end

        def catalog_stories(catalog)
          Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
        end

        def choose_adventure(inflection)
          question_builder = QuestionBuilder.new(inflection: inflection)
          question = question_builder.question
          answer_key = ask(question)
          answer = question_builder.answer_from(answer_key)
          "#{inflection}/#"

        end
      end
    end
  end
end
