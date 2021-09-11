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
          @inflection = inflection
          question = QuestionBuilder.new(inflection).question
          # ask(question)
        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_lcollection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          return if plot_choices.empty?
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: build_question_options(inflection))
        end

        def ask_question(prompt, choices)
          ask("#{prompt}\n\n", { limited_to: choices.keys })
        end

        def question(filedir)
          collection_name = filedir.split('/').last
          "Please choose from these #{collection_name}:"
        end
      end
    end
  end
end
