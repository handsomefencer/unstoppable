# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('delta') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  Given(:adventure) { subject.adventure_for(*picks) }

  describe '#adventure_for()' do
    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          pretty_tags: %w[Ruby_on_Rails Alpine_Linux Docker Devise Stripe_Payments Postgres],
          versions: {"rails"=>"6.1"}
        }
      end

      describe 'when picks arg is an array' do
        When(:picks) { %i[1 1 1 1 1 1] }
        Then { assert_equal(expected[:pretty_tags], adventure[:pretty_tags])}
      end
    end
  end
end
