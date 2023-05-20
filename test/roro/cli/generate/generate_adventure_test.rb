# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_adventure' do
  Given { skip }
  Given(:subject)   { Roro::CLI.new }
  Given(:workbench) { 'test_adventure/lib' }
  Given(:base)      { 'lib/roro/stacks' }
  Given(:adventure) { "#{base}/#{story}" }
  Given(:generated) { "#{adventure}/#{file}" }
  Given(:generate)  { quiet { subject.generate_adventure(story) } }

  context 'when story story named like starwars' do
    Given(:story) { 'starwars' }
    Given { generate }

    describe 'must generate storyfile' do
      Given(:file) { 'starwars.yml' }
      Then { assert_file generated, /preface:/ }
      And  { assert_file generated, /# env/ }
      And  { assert_file generated, /# actions/ }
    end

    describe 'must generate test file with newlines of' do
      Given(:file) { 'test/0/_test.rb' }

      Then { assert_file generated, /# frozen_string_literal/ }
      And  { assert_file generated, /\nrequire ['"]test_helper['"]/ }
    end
  end

  context 'when story story named like starwars/episodes/empire-strikes' do
    Given(:story) { 'starwars/episodes/empire-strikes' }
    Given { generate }

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

    describe 'must generate test directory' do
      Given(:file) { 'test' }
      Then { assert_file generated }

      describe 'with adventure index directory' do
        Given(:file) { 'test/0' }
        Then { assert_file generated }

        describe 'with _test.rb' do
          Given(:file) { 'test/0/_test.rb' }
          Then { assert_file generated }
        end

        describe 'with dummy directory' do
          Given(:file) { 'test/0/dummy/.keep' }
          Then { assert_file generated }
        end
      end
    end
  end
end
