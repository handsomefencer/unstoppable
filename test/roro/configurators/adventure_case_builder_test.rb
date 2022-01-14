# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:case_builder)    { AdventureCaseBuilder.new(stack_loc) }
  Given(:matrixes_path)   { 'test/fixtures/matrixes' }
  Given(:cases_loc)       { "#{matrixes_path}/cases.yml" }
  Given(:itineraries_loc) { "#{matrixes_path}/itineraries.yml" }
  Given(:cases)           { read_yaml(cases_loc) }
  Given(:itineraries)     { read_yaml(itineraries_loc) }
  Given(:itinerary)       { itineraries[cases.index(adventure)][0] }

  describe '#cases_from_stack(stack)' do
    Given(:base)        { "#{Roro::CLI.stacks}/unstoppable_developer_styles" }
    Given(:ruby_stacks) { "#{base}/okonomi/languages/ruby/frameworks"}
    Given(:expected)    { case_builder.adventures_from(stack) }

    context 'simple' do
      Given(:stack) { "#{base}/devops/ci_styles/circleci" }
      Then { assert_equal [[1,1]], expected }
    end

    context 'intermediate' do
      Given(:stack) { "#{ruby_stacks}/ruby_gem" }
      Then { assert_includes expected, [3,2,2,1] }
      And  { assert_includes expected, [3,2,2,2] }
    end

    context 'advanced' do
      Given(:stack) { "#{ruby_stacks}/rails/versions/v6_1" }
      Then { assert_equal expected.size, 8 }
      And  { assert_includes expected, [3, 2, 1, 1, 1, 1, 1] }
      And  { assert_includes expected, [3, 2, 1, 2, 2, 1, 2] }
    end
  end

  describe '#build_cases' do
    When(:expected) { [:inflections, :stacks, :stories] }
    Then { assert_equal expected, case_builder.build_cases.keys }
  end

  describe 'test helpers #generate_fixtures' do
    Given(:workbench) { 'test' }

    context 'before first run' do
      describe 'itineraries.yml' do
        Then { refute File.exist?(cases_loc) }
        And  { refute File.exist?(itineraries_loc) }
      end
    end

    context 'after first run' do
      Given { generate_fixtures }

      describe 'must generate' do
        describe 'fixture file in' do
          describe 'itineraries.yml' do
            Then { assert_file itineraries_loc }
          end

          describe 'cases.yml' do
            Then { assert_file cases_loc }
          end
        end

        describe 'correct number of' do
          describe 'cases' do
            Then { assert_equal 33, cases.size }
          end

          describe 'itineraries' do
            Then { assert_equal 33, itineraries.size }
          end
        end

        describe 'simple' do
          Given(:adventure) { [1,1] }

          Then { assert_equal cases[0], adventure }
          And  { assert_match /ci_styles\/circleci/, itinerary }
        end
      end

      describe 'intermediate case' do
        Given(:adventure) { [3,1,2,1] }
        Then { assert_includes cases, adventure }
        And  { assert_match /flask/, itinerary }
      end

      describe 'advanced case' do
        Then { assert_includes cases, [3,2,1,1,2,2,1] }
      end
    end
  end
end
