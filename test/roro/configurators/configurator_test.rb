# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  Given(:options)    { {} }
  Given(:config)     { Configurator.new }
  Given(:adventures) { %w[fatsufodo django] }
  Given { use_stub_stack }
  context 'without options' do
    describe '#initialize' do
      Then { assert_match 'lib/roro/stacks', config.stack }
      And  { assert_equal Hash, config.structure.class }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end
  end
end
