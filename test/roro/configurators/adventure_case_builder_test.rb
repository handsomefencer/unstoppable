# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)     { Roro::CLI.stacks }
  Given(:case_builder)  { AdventureCaseBuilder.new(stack_loc) }
  Given(:matrixes_path) { 'test/fixtures/matrixes' }
  Given(:expected)      { read_yaml("#{Dir.pwd}/#{file}") }
  Given(:file)          { "#{matrixes_path}/#{matrix}.yml" }
  Given(:content)       { read_yaml("#{Dir.pwd}/#{file}") }


  describe '#build_cases' do
    When(:expected) { [:inflections, :stacks, :stories] }
    Then { assert_equal expected, case_builder.build_cases.keys }
  end

  describe '#generate_fixture_cases' do
    Given(:matrix) { 'cases' }
    Given { case_builder.generate_fixture_cases }

    describe 'must generate file' do
      Then { assert_file file }

      describe 'must generate file' do
        Then { assert_equal 'blah', expected }
      end
    end
  end

  describe '#case_from_path' do
    Given(:stack) { %W[#{Roro::CLI.stacks}/sashimi
      stories/kubernetes
      stories/ingress
      stories/nginx
      stories/cert_manager].join('/')}
    Given(:expected) { %w[sashimi kubernetes ingress nginx cert_manager] }
    # Then { assert_equal expected, case_builder.case_from_path(stack) }
  end

  describe '#case_from_stack' do
    Given(:stack) { %W[#{Roro::CLI.stacks}/sashimi
      stories/kubernetes
      stories/ingress
      stories/nginx
      stories/cert_manager].join('/')}
    Given(:expected) { [5, 1, 1, 1, 1] }
    # Then { assert_equal expected, case_builder.case_from_stack(stack) }
  end
end
