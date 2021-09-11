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

        def choose_adventure(inflection)
          @inflection = inflection
          question = build_question
          # ask(question)
        end

        def build_question
          prompt = build_question_prompt
          options = build_question_options
          ["#{prompt} #{options}", limited_to: options.keys]
        end

        def build_question_prompt
          prompt = 'Please choose from these'
          tree = @inflection.split('/')
          [prompt, tree[-2], tree.last].join(' ')
        end

        def build_question_options
          Hash.new.tap do |h|
            get_children(@inflection)
                        .map { |f| f.split('/').last }
                        .sort
                        .each_with_index do |c, i|
              h[(i + 1).to_s] = c.split('.').first
            end
          end
        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_lcollection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          return if plot_choices.empty?
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: build_question_options(inflection))
        end

        # def get_story_preface(catalog)
        #   name = catalog.split('/').last.split('.').first
        #   case
        #   when node_empty?(catalog)
        #     preface = nil
        #   when node_missing?(catalog)
        #     preface = nil
        #   when node_is_file?(catalog)
        #     preface = read_yaml(catalog)[:preface]
        #   else
        #     preface = read_yaml("#{catalog}/#{name}.yml")[:preface]
        #   end
        #   hash = { name.to_sym => preface }
        #   hash
        # end

        def node_missing?(node)
          !File.exists?(node)
        end

        def node_empty?(node)
          Dir.glob("#{node}/**").empty?
        end

        def node_is_file?(node)
          File.file?(node)
        end

        def node_exists?(node)

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
