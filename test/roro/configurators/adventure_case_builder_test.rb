# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new("#{Roro::CLI.roro_root}/stacks") }
  Given(:expected) { read_yaml("#{Roro::CLI.test_root}/helpers/adventure_cases.yml") }

  describe '#build_cases' do
    Given { case_builder.build_cases }
    Then  { assert_equal case_builder.cases, expected }
  end

  describe '#document_cases' do
    Given { case_builder.build_cases }
    Given { case_builder.document_cases }
    Then  { assert_file "#{Dir.pwd}/test/helpers/adventure_cases.yml" }
  end
end
