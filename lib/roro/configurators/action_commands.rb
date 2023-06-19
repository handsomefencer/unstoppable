# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser
      include Utilities

      attr_reader :answers, :itinerary, :stack, :manifest, :choices

      def initialize
        @asker     = AdventurePicker.new
        @itinerary = []
        @stack     = Roro::CLI.stacks
      end

      def record_answers(s = @stack, r = [])
        case stack_type(s)
        when :inflection
          a = choose_adventure(s)
          record_answers(children(s)[(a.to_i - 1)], r << a)
        when :story
          @itinerary << stack.split("#{Roro::CLI.stacks}/").last
        else
          children(s).each { |c| record_answers(c, r) }
        end
        @itinerary.uniq!
        @answers = r
      end

      def build_itinerary(stack = nil)
        @manifest ||= []
        stack ||= @stack
        case stack_type(stack)
        when :storyfile
          @manifest << stack
        when :story
          @itinerary << stack.split("#{Roro::CLI.stacks}/").last
          @manifest += stack_stories(stack)
        when :stack
          @manifest += stack_stories(stack)
          children(stack).each { |c| build_itinerary(c) }
        when :inflection_stub
          children(stack).each { |c| build_itinerary(c) }
        when :inflection
          child = choose_adventure(stack)
          build_itinerary(child)
        end
        @manifest.uniq!
        @itinerary.uniq!
      end

      def choose_adventure(inflection)
        @asker.choose_adventure(inflection)
      end
    end
  end
end
