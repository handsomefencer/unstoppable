# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_adventure' do
  Given { skip }
  Given(:workbench) { 'test_adventure/lib' }
  Given(:base)      { 'lib/roro/stacks' }
  Given(:adventure) { "#{base}/#{story}" }
  Given(:generated) { "#{adventure}/#{file}" }
  Given(:generate)  { Roro::CLI.new.generate_adventure(story) }

  context 'when story story named like starwars' do
    Given(:story) { 'starwars' }
    Given { quiet { generate } }

    describe 'must generate storyfile' do
      Given(:file) { 'starwars.yml' }
      Then { assert_file generated, /preface:/ }
      And  { assert_file generated, /# env/ }
      And  { assert_file generated, /# actions/ }
    end
  end

  context 'when story story named like starwars/episodes/empire-strikes' do
    Given(:story) { 'starwars/episodes/empire-strikes' }
    Given { quiet { generate } }

    describe 'must generate storyfile' do
      Given(:file) { 'empire-strikes.yml' }
      Then { assert_file generated, /preface:/ }
    end

    describe 'must generate templates directory' do
      Given(:file) { 'templates' }
      Then { assert_file generated }

      describe 'with manifest/.keep' do
        Given(:file) { 'templates/manifest/.keep' }
        Then { assert_file generated }
      end
    end
  end
end
