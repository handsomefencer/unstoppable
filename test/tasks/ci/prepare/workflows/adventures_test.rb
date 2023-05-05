# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare:workflows:adventures' do
  Given(:workbench) { '.circleci' }

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
          Then { assert_equal 27, answers.size }
        end

        describe 'with correct answers' do
          Given(:expected) do
            [
              '1\\n1\\n1',
              '1\\n1\\n2',
              '1\\n2\\n1\\n1\\n1',
              '1\\n2\\n1\\n1\\n2',
              '1\\n2\\n1\\n2\\n1',
              '1\\n2\\n1\\n2\\n2',
              '1\\n2\\n2\\n1',
              '1\\n2\\n2\\n2',
              '1\\n3\\n1\\n1\\n1\\n1\\n1',
              '1\\n3\\n1\\n1\\n1\\n1\\n2',
              '1\\n3\\n1\\n1\\n1\\n2\\n1',
              '1\\n3\\n1\\n1\\n1\\n2\\n2',
              '1\\n3\\n1\\n1\\n2\\n1\\n1',
              '1\\n3\\n1\\n1\\n2\\n1\\n2',
              '1\\n3\\n1\\n1\\n2\\n2\\n1',
              '1\\n3\\n1\\n1\\n2\\n2\\n2',
              '1\\n3\\n1\\n2\\n1\\n1',
              '1\\n3\\n1\\n2\\n1\\n2',
              '1\\n3\\n1\\n2\\n2\\n1',
              '1\\n3\\n1\\n2\\n2\\n2\\n2',
              '1\\n3\\n2\\n1',
              '1\\n3\\n2\\n2',
              '2\\n1',
              '2\\n2',
              '3\\n1\\n1\\n1\\n1',
              '3\\n2',
              '3\\n1\\n1'
            ]
          end

          # focus
          Then do
            expected.each do |expected_answer|
              assert_includes answers, expected_answer
            end
          end
        end
      end
    end
  end
end
