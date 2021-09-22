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
          when catalog_is_empty?(catalog)
            return
          when catalog_is_node?(catalog)
            get_children(catalog).each do |child|
              build_itinerary(child)
            end
          when catalog_is_inflection?(catalog)
            choice = "#{catalog}/#{choose_adventure(catalog)}"
            @itinerary << choice unless catalog_is_parent?(choice)
            build_itinerary(choice)
          end
        end
      end
    end
  end
end
