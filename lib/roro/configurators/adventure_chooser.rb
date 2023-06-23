# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureChooser
      include Utilities

      attr_reader :answers, :stack

      def initialize
        @asker     = AdventurePicker.new
        @itinerary = []
        @stack     = Roro::CLI.stacks
      end

      def record_answers(s = @stack, r = [])
        if stack_type(s).eql?(:inflection)
          a = @asker.choose_adventure(s)
          record_answers(children(s)[(a.to_i - 1)], r << a)
        else
          children(s).each { |c| record_answers(c, r) }
        end
        r
      end
    end
  end
end
