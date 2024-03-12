# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_active_stack }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  Given(:adventure) { subject.adventure_for(*picks) }

  describe '#adventure_for()' do
    describe 'when adventure is okonomi php laravel' do
      # Given(:expected) do
      #   {
      #     pretty_tags: %w[Ruby_on_Rails Alpine_Linux Docker Devise Stripe_Payments Postgres],
      #     versions: {"rails"=>"6.1"}
      #   }
      # end

      describe 'when picks arg is an array' do
        When(:picks) { %i[1 1 2 3 2 2 2  3] }
        Given(:expected) { { pretty_tags: [
          "Ruby_on_Rails", "Alpine_Linux", "Docker_Compose",
          "Git", "Devise", "Stripe", "Mariadb", "Redis", "Sidekiq"]}}

        Then { assert_equal('blah', adventure.dig(:pretty_tags))}
          focus
        Then { assert_equal('blah', adventure.dig(:versions))}
      end
    end
  end
end
