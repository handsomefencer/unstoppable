# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given(:workbench) { }
  Given(:writer)  { AdventureWriter.new }
  Given(:env)     { { :env => { } } }
  Given(:base)    { "#{Roro::CLI.stacks}/unstoppable_developer_styles/okonomi" }
  Given(:story)   { "#{base}/languages/ruby/frameworks/rails/versions/v6_1/v6_1.yml" }

  describe '#manifest_paths' do
    Given {
      writer.instance_variable_set(:@env, env)
      writer.instance_variable_set(:@storyfile, story)
    }
    # Then { assert_equal 'blah', writer.set_manifest_paths }
  end

  describe '#writ' do
    Given { writer.write(env, story) }
    Then  { writer.copy_manifest }
  end
end