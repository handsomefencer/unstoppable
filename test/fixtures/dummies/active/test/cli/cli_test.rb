# frozen_string_literal: true

require 'test_helper'

describe Roro::CLI do
  Given(:cli) { Roro::CLI.new }

  describe 'commands' do
    Given(:mappings) do
      {
        generate_containers: ['generate:containers'],
        generate_exposed: ['generate:exposed'],
        generate_environments: ['generate:environments'],
        generate_keys: ['generate:key'],
        generate_mise: ['generate:mise'],
        generate_obfuscated: ['generate:obfuscated'],
        generate_adventure_tests: ['generate:adventure_tests'],
        rollon: ['rollon']
      }
    end

    describe 'mapping' do
      Then do
        mappings.each do |command, command_calls|
          assert_includes Roro::CLI.commands.keys, command.to_s
          command_calls.each do |command_call|
            assert_includes Roro::CLI.map.keys, command_call.to_s
            assert_equal Roro::CLI.map[command_call], command.to_s
          end
        end
      end
    end
  end
end
