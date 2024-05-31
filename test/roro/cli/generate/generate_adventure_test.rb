# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_adventure' do
  Given(:workbench) { 'test_adventure/lib' }
  Given(:generate)  { Roro::CLI.new.generate_adventure(path) }
  Given(:path) { 'lib/roro/stacks/starwars' }
  Given(:stack) { path }

  Given { quiet { generate } }

  describe 'when path is like lib/roro/stacks/starwars' do
    Then { assert_directory stack }
  end

  describe 'when path is like lib/roro/stacks/starwars/episodes/iv' do
    When(:path) { 'lib/roro/stacks/starwars/episodes/iv' }
    Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/.keep' }
  end

  describe 'must generate storyfile' do
    Given(:storyfile) { "#{stack}/starwars.yml" }
    Then { assert_content storyfile, /preface:/ }
    And  { assert_content storyfile, /# env/ }
    And  { assert_content storyfile, /# actions/ }
  end

  describe 'must generate templates directory' do
    Then { assert_file "#{stack}/templates/.keep" }
  end

  describe 'must generate builder directory' do
    Then { assert_file "#{stack}/templates/builder/.keep" }
  end

  describe 'must generate partials' do
    Then { assert_file "#{stack}/templates/partials/.keep" }
  end
end
