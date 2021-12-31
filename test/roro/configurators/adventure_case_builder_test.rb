# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)    { "#{Roro::CLI.stacks}" }
  Given(:case_builder) { AdventureCaseBuilder.new(stack_loc) }
  Given(:expected)     { read_yaml("#{Dir.pwd}/mise/logs/matrix_cases.yml") }

  describe '#build_cases' do
    When(:expected) { [:inflections, :stacks, :stories] }
    Then { assert_equal expected, case_builder.build_cases.keys }
  end

  describe '#build_cases_matrix' do
    Given(:result) { case_builder.build_cases_matrix }

    Then {
      assert_includes result, [:devops, :circleci]
      assert_includes result, [:fatsufodo, :django]
      assert_includes result, [:fatsufodo, :rails]
      assert_includes result, [:okonomi, :python, :django, :v3_9_9]
      assert_includes result, [:sashimi, :rails]
      assert_includes result, [:sashimi, :kubernetes, :ingress, :nginx,
                               :cert_manager]
      assert_includes result, [:okonomi, :ruby, :rails, :mariadb, :v10_7_1,
                                :v6_1, :v2_7]
      assert_includes result, [:okonomi, :ruby, :rails, :postgres, :v13_5,
                               :v6_1, :v3_0]
      assert_equal result.size, 33
    }
  end

  describe '#document_cases' do
    Given { case_builder.document_cases }
    focus
    Then  { assert_file "#{Dir.pwd}/mise/logs/cases_matrix.yml" }
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
