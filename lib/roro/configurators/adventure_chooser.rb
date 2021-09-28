# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions

      attr_reader :catalog, :itinerary

      no_commands do
        def initialize
          @catalog   = Roro::CLI.catalog_root
          @itinerary = []
        end

        def build_itinerary(catalog=nil)
          catalog ||= @catalog
          case
          # when catalog_is_alias?(catalog)
          #   @itinerary += read_yaml(catalog)[:aliased_to]
          when stack_is_stack?(catalog)
            children(catalog).each { |c| build_itinerary(c) }
          # when stack_is_parent?(catalog)
          #   children(catalog).each { |c| build_itinerary(c) }
          when stack_is_inflection?(catalog)
            choice = choose_adventure(catalog)
            @itinerary << choice if stack_is_story?(choice)
            build_itinerary(choice)
          end
          @itinerary
        end

        def catalog_is_alias?(catalog)
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
