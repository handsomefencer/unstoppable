# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions

      attr_reader :itinerary, :stack, :manifest

      no_commands do
        def initialize
          @stack   = Roro::CLI.catalog_root
          @itinerary = []
        end

        def build_itinerary(stack=nil)
          @manifest ||= []
          stack ||= @stack
          case stack_type(stack)
          when :story
            @manifest += stack_stories(stack)
          when :stack
            @manifest += stack_stories(stack)
            children(stack).each { |c| build_itinerary(c) }
          when :inflection
            child = choose_adventure(stack)
            @itinerary << child if stack_type(child).eql?(:story)
            build_itinerary(child)
          end
          @itinerary.uniq
        end

        def stack_is_alias?(catalog)
          stack_is_storyfile?(catalog) &&
            !read_yaml(catalog)[:aliased_to].nil?
        end

        def choose_adventure(inflection)
          builder = QuestionBuilder.new(inflection: inflection)
          question = builder.build_inflection

          "#{inflection}/#{ask(question)}"
        end
      end
    end
  end
end
