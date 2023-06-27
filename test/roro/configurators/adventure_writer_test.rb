# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given { use_fixture_stack('alpha') }

  Given(:workbench) {}
  Given(:writer)    { AdventureWriter.new }

  describe 'partials_for(stack)' do
    Given(:stack_base) do
      [Roro::CLI.test_root,
       'fixtures/files/stacks/alpha/unstoppable_developer_styles',
       'okonomi/languages/ruby'].join('/')
    end

    Given(:result) { writer.partials_for(stack) }

    describe 'when stack has immediate partials' do
      Given(:expected) do
        [%r{rails/templates/partials/packages/_base\.erb},
         %r{rails/templates/partials/services/_app\.erb},
         %r{rails/templates/partials/shared/_env_file\.erb},
         %r{rails/templates/partials/volumes/_base\.erb}]
      end

      describe 'when rails/rails.yml' do
        When(:stack) { stack_base + '/frameworks/rails/rails.yml' }

        Then do
          assert_equal 4, result.count
          expected.each_with_index { |e, i| assert_match e, result.dig(i) }
        end
      end

      describe 'when rails/databases.yml' do
        When(:stack) { stack_base + '/frameworks/rails/databases.yml' }

        Then do
          expected.each_with_index { |e, i| assert_match e, result.dig(i) }
        end
      end
    end

    describe 'when stack has no partials' do
      When(:stack) { stack_base + '/ruby.yml' }
      Then { assert_equal([], result) }
    end

    describe 'when stack has no partials' do
      When(:stack) { stack_base + '/ruby.yml' }
      Then { assert_equal([], result) }
    end
  end
end
