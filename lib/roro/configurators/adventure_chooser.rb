# frozen_string_literal: true

require_relative 'validations'
require_relative 'utilities'

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions
      include Validations
      include Utilities

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

        def catalog_is_node?(catalog)
          get_children(catalog).any? { |w| w.include? '.yml' }
        end

        def catalog_is_story?(catalog)
          %w[yml yaml].include?(story_name(catalog).split('.').last)
        end

        def catalog_is_inflection?(catalog)
          catalog_stories(catalog).empty?
        end

        def catalog_stories(catalog)
          Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
        end

        def question_builder(inflection)
          prompt = 'Please choose from these'
          parent = inflection.split('/')[-2]
          collection = inflection.split('/').last
          choices = get_plot_choices(inflection)
          # question = [prompt, parent, collection, choices].join(' ')

        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_collection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          return if plot_choices.empty?
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: plot_choices.keys.map(&:to_s))
        end

        def get_plot_choices(scene)
          choices = get_children(scene)
                      .map { |f| f.split('/').last }
                      .sort
          Hash.new.tap do |h|
            choices.each_with_index { |c, i| h[i + 1] = c.split('.yml').first }
          end
        end

        def get_story_preface(scene)
          read_yaml(scene)[:preface]
        end

        def story_name(catalog)
          catalog.split('/').last
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
