# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new("#{Roro::CLI
                                                       .roro_root}/stacks/unstoppable/developer_styles") }
  Given(:expected) { read_yaml("#{Roro::CLI.test_root}/helpers/experiment_cases.yml") }

  Given { case_builder.build_cases }

  describe '#build_matrix' do
    focus
    Then { assert_equal case_builder.build_matrix, 'expected'  }
  end

  describe '#document_cases' do
    Given { case_builder.document_cases }
    focus
    Then  { assert_file "#{Dir.pwd}/test/helpers/experimental_cases.yml" }
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

  describe '#matrix_cases' do
    # Then { assert_includes case_builder.matrix_cases, [3,2,1,1,1] }
  end

  describe '#matrix_cases_human' do
    # Given { case_builder.matrix_cases_human }
    # Then { assert_equal case_builder.human, 'blah'}
    # Then { assert_includes case_builder.matrix_cases_human, [:okonomi,:ruby,
    #                                                          :rails,:v6_1,
    #                                                          :v2_7] }
  end
end
