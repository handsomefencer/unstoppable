# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions

      attr_reader :catalog, :itinerary, :stack

      no_commands do
        def initialize
          @stack   = Roro::CLI.catalog_root
          @itinerary = []
        end

        def build_itinerary(stack=nil)
          stack ||= @stack
          case stack_type(stack)
          when :story
            @itinerary << stack
          when :stack
            all_inflections(stack).each { |i| build_itinerary(i) }
            children(stack).each { |c| build_itinerary(c) }
          when :inflection
            build_itinerary(choose_adventure(stack))
          end
          @itinerary
        end

        def stack_is_alias?(catalog)
          stack_is_storyfile?(catalog) &&
            !read_yaml(catalog)[:aliased_to].nil?
        end

        def choose_adventure(inflection)
          builder = QuestionBuilder.new(inflection: inflection)
          builder.build_from_inflection
          "#{inflection}/#{builder.story_from(ask(builder.question))}"
        end
      end
    end
  end
end
