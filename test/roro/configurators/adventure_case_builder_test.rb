# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new("#{Roro::CLI.roro_root}/stacks/catalog") }
  Given(:expected) { read_yaml("#{Roro::CLI.test_root}/helpers/story_finder.yml") }

  describe '#build_cases' do
    Given(:cases) { case_builder.build_cases }
    focus
    # Then { assert_equal cases.keys, expected }
    Then { assert_equal cases, expected }
  end
end
