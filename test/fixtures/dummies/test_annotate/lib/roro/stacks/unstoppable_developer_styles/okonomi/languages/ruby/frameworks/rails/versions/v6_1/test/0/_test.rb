# frozen_string_literal: true

require 'test_helper'

describe "#{adventure_name(__FILE__)}" do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }
  Given(:adventure)  { 0 }

  Given { quiet { rollon } }

  describe 'must generate a' do
  end
end
