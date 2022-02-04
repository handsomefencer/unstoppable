# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given(:workbench) { }
  Given(:writer)  { AdventureWriter.new }
  Given(:env)     { { :env => { } } }
  Given(:base)    { "#{Roro::CLI.stacks}/unstoppable_developer_styles/okonomi" }
  Given(:story)   { "#{base}/languages/ruby/frameworks/rails/versions/v6_1/v6_1.yml" }

  Given {
    writer.instance_variable_set(:@env, env)
    writer.instance_variable_set(:@storyfile, story)
  }

  describe 'partials' do
    describe 'must return an array of ancestor partials' do
      Then { assert_match '_packages.erb', writer.partials.first }
    end
  end

  describe 'partial(storyfile)' do
    describe 'must return the most specific partial' do
      Given(:partials) { writer.partials }
      Then { assert_equal 'blah', writer.partial('packages') }
      # Then { assert_equal writer.partials, 'blah' }
    end
  end

  describe '#manifest_paths' do
    Given {
      writer.instance_variable_set(:@env, env)
      writer.instance_variable_set(:@storyfile, story)
    }
    # Then { assert_equal 'blah', writer.set_manifest_paths }
  end

  describe '#writ' do
    # Given { writer.write(env, story) }
    # Then  { writer.copy_manifest }
  end
end