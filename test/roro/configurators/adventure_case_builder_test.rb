# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new("#{Roro::CLI.roro_root}/stacks/catalog") }
  Given(:expected) { read_yaml("#{Roro::CLI.test_root}/helpers/cases.yml") }

  describe '#build_cases' do
    Given{ case_builder.build_cases }
    # Given do
    #   # File.open("#{Dir.pwd}/test/helpers/cases.yml", "w") { |f| f.write(case_builder.cases.to_yaml) }
    # end
    Then { assert_equal case_builder.cases, expected }
  end
end
