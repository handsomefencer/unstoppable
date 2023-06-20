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
          byebug
          record_answers(children(s)[(a.to_i - 1)], r << a)
        when :story
          @itinerary << stack.split("#{Roro::CLI.stacks}/").last
        else
          children(s).each { |c| record_answers(c, r) }
        end
        @itinerary.uniq!
        @answers = r
      end

      def choose_adventure(inflection)
        @asker.choose_adventure(inflection)
      end
    end
  end
end
