# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:subject) { Roro::CLI.new }
  Given(:workbench) { 'test_adventure/lib' }
  Given(:base)      { 'test/roro/stacks' }
  # Given(:generate)  { quiet { subject.choice_tests } }
  Given(:generate) { subject.choice_tests }

  Given { generate }

  describe 'must generate nested directories' do
    Then { assert_file '.harvest.yml' }

    describe 'with content' do
      Given(:content) { read_yaml('.harvest.yml') }

      describe 'title' do
        # Given(:title) { content[:metadata][:adventures][:"8"][:title] }
        Given(:title) { content }
        # focus
        # Then { assert_match(/docker postgres:13.5 rails:6.1 ruby:2.7/, title) }
      end
    end
  end
end
