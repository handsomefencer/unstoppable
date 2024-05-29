# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::ConfiguratorTestHelper do
  describe "#rollon_options" do
    Given(:one) { rollon_options.dig(:debuggerer) }
    Given(:two) { rollon_options.dig(:rollon_loud) }
    Given(:three) { rollon_options.dig(:rollon_dummies) }
    Given { ENV['DEBUGGERER'] = nil }

    describe 'default' do
      Then { refute one }
      And { refute two }
      And { refute three }
    end

    describe 'when set in env' do
      Given { ENV['DEBUGGERER'] = 'true'}
      Then { assert one }
      And { refute two }
      And { refute three }
    end

    describe 'when set with debuggerer cal' do
      Given { debuggerer }
      Then { refute one }
      And { assert two }
      And { assert three }
    end
  end

  describe '#assert_correct_manifest(dir)' do
    Given(:workbench) { }
    Given(:dir) { [
      Roro::CLI.test_root,
      "fixtures/files/test_stacks/foxtrot",
      "stacks/tailwind/sqlite/importmaps/okonomi"
      ].join('/')}
    Given { use_fixture_stack('foxtrot') }
focus
    Then { assert_correct_manifest(dir)}

  end
end
