# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare:workflows:adventures' do
  Given(:workbench) { '.circleci' }

  Given { run_task('club:harvest') }

  describe 'harvest.yml' do
    Given(:file)      { 'harvest.yml' }
    Given(:data)     { read_yaml(file).dig(:jobs, 0, :"test-adventures") }
    Given(:answers)  {  data.dig(:matrix, :parameters, :answers) }

    describe 'must exist' do
      focus
      Then { assert_file file }

      describe 'with adventure workflow' do
        Then { assert_equal answers[0], "1\\n1\\n1" }

        describe 'with correct number of answers' do
          Then { assert_equal 27, answers.size  }
        end
        describe 'with correct answers' do
          Then { assert_equal answers[0], "1\\n1\\n1" }
          And  { assert_equal answers[5], "1\\n2\\n1\\n1\\n2" }
        end
      end
    end


  end

end