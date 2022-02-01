# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_adventure' do
  Given(:subject)        { Roro::CLI.new }
  Given(:workbench)      { 'test_adventure/lib' }
  Given(:base)           { 'lib/roro/stacks' }
  Given(:adventure)   { 'starwars/episodes/iv' }
  Given(:generate) { subject.generate_adventure(adventure) }

  Given { generate }

  describe 'must generate' do
    describe 'storyfile' do
      Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/iv.yml' }
    end

    describe 'templates directory' do
      Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/templates' }

      describe 'manifest' do
        Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/templates/manifest' }
      end
    end

    describe 'test directory' do
      Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/test' }

      describe 'adventure index directory' do
        Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/test/0' }

        describe 'adventure dummy directory' do
          Then { assert_file 'lib/roro/stacks/starwars/episodes/iv/test/0/dummy/.keep' }
        end
      end
    end

    describe '_test.rb' do
      Given(:file) { 'lib/roro/stacks/starwars/episodes/iv/test/0/_test.rb'}
      Then { assert_file file }
      And do
        save_result(File.read(file), 'generate_adventure.rb' )
        end
    end

  end
end
