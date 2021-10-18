# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'roll_your_own', 'Generate mise en place'
    map 'roll_your_own'  => 'roll_your_own'

    def roll_your_own(stack_path = nil)

    end
  end
end
