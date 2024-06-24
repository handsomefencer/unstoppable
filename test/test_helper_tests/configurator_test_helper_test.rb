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

  describe '#evaluate_contents_hash' do
    Given(:dir) { "/usr/src/test/roro/stacks/tailwind/sqlite/importmaps/okonomi" }
    Given(:file) { :"#{dir}/dummy/docker-compose.development.yml" }
    Given(:expected) {{ services: { prod!: {}, :dev=> {
            :container_name=>"dev",
            :profiles=>["development"]
    }}}}
    Given(:result) { evaluate_contents_hash('bar', file, expected) }
    Then { assert_equal 'dev', result.dig(:services, :dev, :container_name) }
    And { assert_equal 'development', result.dig(:services, :dev, :profiles, 0) }
  end
end
