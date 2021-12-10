# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)    { "#{Roro::CLI
    .stacks}/unstoppable/developer_styles/okonomi/languages/ruby" }

  Given(:case_builder) { AdventureCaseBuilder.new(stack_loc) }
  Given(:expected)     { read_yaml("#{Dir.pwd}/mise/logs/matrix_cases.yml") }

  describe '#build_cases' do
    Then { assert_equal case_builder.cases, expected }
  end

  describe '#build_matrix' do
    focus
    Then { assert_equal case_builder.build_matrix, 'expected'  }
  end

  describe '#document_cases' do
    Given { case_builder.document_cases }
    # Then  { assert_file "#{Dir.pwd}/mise/logs/matrix_cases.yml" }
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
