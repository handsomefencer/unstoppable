# frozen_string_literal: true

require 'test_helper'

describe 'Roro::Configurators::AdventureChooser' do
  Given { use_fixture_stack('alpha') }

  Given(:subject) { Roro::Configurators::AdventureChooser.new }

  describe '#record_answers' do
    Given(:result) do
      stub_journey(answers)
      quiet { subject.record_answers }
    end

    describe 'when okonomi php laravel' do
      When(:answers) { %w[1 1 1] }
      Then { assert_equal(%w[1 1 1], result) }
    end

    describe 'when okonomi ruby rails pg' do
      When(:answers) { %w[1 3 1 1 2 2 2 2] }
      Then { assert_equal(%w[1 3 1 1 2 2 2 2], result) }
    end

    describe 'when sashimi rails' do
      When(:answers) { %w[3 2] }
      Then { assert_equal(%w[3 2], result) }
    end
  end
end
