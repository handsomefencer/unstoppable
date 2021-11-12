# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new("#{Roro::CLI.roro_root}/stacks") }
  Given(:expected) { read_yaml("#{Roro::CLI.test_root}/helpers/adventure_cases.yml") }

  Given { case_builder.build_cases }

  describe '#build_cases' do
    Then { assert_equal case_builder.cases, expected }
  end

  describe '#document_cases' do
    Given { case_builder.document_cases }
    Then  { assert_file "#{Dir.pwd}/test/helpers/adventure_cases.yml" }
  end

  describe '#case_from_stack' do
    Given(:stack) { %W[#{Roro::CLI.stacks}/sashimi
      stories/kubernetes
      stories/ingress
      stories/nginx
      stories/cert_manager].join('/')}
    Given(:expected) { %w[sashimi kubernetes ingress nginx cert_manager] }
    Then { assert_equal expected, case_builder.case_from_path(stack) }
  end
end
