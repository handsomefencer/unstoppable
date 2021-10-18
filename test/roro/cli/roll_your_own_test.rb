# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#roll_your_own' do
  Given(:cli)        { Roro::CLI.new }
  Given(:workbench)  { 'lib/roro/stacks' }
  Given(:stack_root) { 'lib/roro/stacks' }
  Given(:stack)      { 'adventure' }

  Given { quiet { cli.roll_your_own(stack_path) } }

  describe 'Roro::CLI.roll_your_own' do
    # Then { }

  end
end
