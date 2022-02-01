# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:case_builder)    { AdventureCaseBuilder.new(stack_loc) }

  describe '#cases_from_stack(stack)' do
    Given(:base)        { "/unstoppable_developer_styles" }
    Given(:ruby_stacks) { "#{base}/okonomi/languages/ruby/frameworks"}
    Given(:expected)    { adventures_from(stack) }

    context 'simple' do
      Given(:stack) { "#{base}/sashimi/devops/ci_styles/circleci" }

      Then { assert_includes expected, [3,2] }
    end

    context 'intermediate' do
      Given(:stack) { "#{ruby_stacks}/ruby_gem" }
      Then { assert_includes expected, [1,3,2,1] }
      And  { assert_includes expected, [1,3,2,2] }
    end

    context 'advanced' do
      Given(:stack) { "#{ruby_stacks}/rails/versions/v6_1" }
      Then { assert_equal expected.size, 6 }
      And  { assert_includes expected, [1,3,1,1,1,1,1] }
      And  { assert_includes expected, [1,3,1,1,2,1,2] }
    end
  end

  describe '#build_cases' do
    When(:expected) { [:inflections, :stacks, :stories] }
    Then { assert_equal expected, case_builder.build_cases.keys }
  end
end
