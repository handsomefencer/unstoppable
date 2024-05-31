# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given(:subject) { Roro::Configurators::StackReflector.new }
  Given(:adventure) { subject.adventure_for(*picks) }

  describe '[:pretty_tags]' do
    Given(:picks) { %i[1 1 1 1 3 1 1 1] }
    Given(:expected) { %w[
      Ruby_on_Rails Alpine_Linux Docker_Compose
      Git RoRo Devise Stripe Mariadb Vite Redis Sidekiq
    ] }
    Then { assert_equal(expected, adventure.dig(:pretty_tags))}
    And { assert_equal('7.1', adventure.dig(:versions, 'rails'))}
  end
end
