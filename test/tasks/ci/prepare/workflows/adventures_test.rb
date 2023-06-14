# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare:workflows:adventures' do
  Given(:workbench) { '.circleci' }
  Given { use_fixture_stack }
  Given { run_task('ci:prepare:workflows:adventures') }

  describe 'adventures.yml' do
    Given(:file) { '.circleci/src/workflows/adventures.yml' }
    Given(:data)     { read_yaml(file).dig(:jobs, 0, :"test-adventures") }
    Given(:answers)  { data.dig(:matrix, :parameters, :answers) }

    describe 'must exist' do
      Then { assert_file file }

      describe 'with adventure workflow' do
        Then { assert_equal answers[0], '1\\n1\\n1' }

        describe 'with correct number of answers' do
          Then { assert_equal 38, answers.size }
        end

        describe 'with correct answers' do
          Then do
            expected_adventure_cases.each do |e|
              assert_includes answers, e.gsub(' ', '\\\n')
            end
          end
        end
      end
    end
  end
end
