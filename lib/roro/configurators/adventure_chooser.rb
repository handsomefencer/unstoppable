# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser

      include Utilities

      attr_reader :itinerary, :stack, :manifest

      def initialize
        @asker     = AdventurePicker.new
        @itinerary = []
        @stack     = Roro::CLI.stacks
      end

      def build_itinerary(stack=nil)
        @manifest ||= []
        stack ||= @stack
        case stack_type(stack)
        when :storyfile
          @manifest << stack
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
        @manifest.uniq!
        @itinerary.uniq!
      end

      def stack_is_alias?(catalog)
        stack_is_storyfile?(catalog) &&
          !read_yaml(catalog)[:aliased_to].nil?
      end

      def choose_adventure(inflection)
        @asker.choose_adventure(inflection)
      end
    end
  end
end
