# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given(:subject) { Roro::Configurators::StackReflector.new }
  Given(:adventure) { subject.adventure_for(*picks) }

  describe '[:pretty_tags]' do
    Given(:picks) { %i[1 1 1 1] }
    Given(:expected) { %w[
      Ruby_on_Rails Alpine_Linux Docker_Compose
      Git RoRo Bootstrap MariaDB Bun Devise
    ] }
    Then { assert_equal(expected, adventure.dig(:pretty_tags))}
  end
end
