# frozen_string_literal: true

require "test_helper"

describe Roro::CLI do

  Given(:cli) { Roro::CLI.new }

  describe 'commands' do
    let(:mappings) { {
      generate_story: ['generate::story'],
      generate_exposed: ['generate::exposed'],
      generate_keys: ['generate::key'],
      omakase_roro: ['omakase::roro'],
      generate_obfuscated: ['generate::obfuscated'],
      greenfield_rails: ['omakase::rails'],
      rollon_rails: ['rollon::rails'],
      rollon_rails_kubernetes: ['rollon::rails::kubernetes'] }
    }

    describe 'mapping' do
      Then { mappings.each { |command, command_calls|
        assert_includes Roro::CLI.commands.keys, command.to_s
        command_calls.each { |command_call|
          assert_includes Roro::CLI.map.keys, command_call.to_s
          assert_equal Roro::CLI.map[command_call], command.to_s
        }}}
    end
  end
end
