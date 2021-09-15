# frozen_string_literal: true

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
      end
    end
  end
end
