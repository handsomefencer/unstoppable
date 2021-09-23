# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser < Thor
      include Thor::Actions

      attr_reader :itinerary, :adventure

      no_commands do
        def initialize(catalog=nil)
          @catalog = catalog || Roro::CLI.catalog_root
          @itinerary = []
          @adventure = []
          build_itinerary
        end

        def build_itinerary(catalog=nil)
          catalog ||= @catalog
          case
          when catalog_is_node?(catalog)
            get_children(catalog).each { |c| build_itinerary(c) }
          when catalog_is_parent?(catalog)
            get_children(catalog).each { |c| build_itinerary(c) }
          when catalog_is_inflection?(catalog)
            choice = choose_adventure(catalog)
            @itinerary << choice unless catalog_is_parent?(choice)
            build_itinerary(choice)
          end
        end

        def choose_adventure(inflection)
          builder = QuestionBuilder.new(inflection: inflection)
          "#{inflection}/#{builder.story_from(ask(builder.question))}"
        end
      end
    end
  end
end
