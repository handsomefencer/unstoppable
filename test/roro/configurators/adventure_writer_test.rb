# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given(:workbench) { }
  Given(:writer)    { AdventureWriter.new }
  Given(:base)      { "#{Roro::CLI.stacks}/unstoppable_developer_styles" }
  Given(:story)     { "#{base}/okonomi/languages/ruby/frameworks" }
  Given(:storyfile) { "#{story}/rails/versions/v6_1/v6_1.yml" }
  Given(:buildenv)  { { env: { base: {
    db_pkg: { value: 'sqlite' },
    bundler_version: { value: '2.3.2' },
    rails_version: { value: '7.1' },
    db_vendor: { value: 'sqlite' },
    ruby_version: { value: '3.0' } } } } }

  # Given {
  #   writer.instance_variable_set(:@env, buildenv)
  #   writer.instance_variable_set(:@storyfile, storyfile)
  # }

  describe '#write' do
    Given { writer.write(buildenv, storyfile) }

    Then { assert_file 'docker-compose.yml' }
  end

  describe '#partials' do
    describe 'must return an array of ancestor partials' do
      # Then { assert_equal Array, writer.partials.class }
      # And  { assert_equal 7, writer.partials.size }
    end
  end

  describe '#partial(storyfile)' do
    describe 'must return interpolation from the most specific partial' do
      Given(:partials) { writer.partials }

      context 'when variable missing' do
        # When(:env) { { base: { db_pkg: { value: 'sqlite' } } } }
        # Then { assert_raises(Roro::Error) { writer.partial('packages') } }
      end

      context 'when variable present' do
        # Then { assert_match 'sqlite', writer.partial('packages') }
      end
    end
  end

  describe '#manifest_paths' do
    # Then { assert_match 'templates/manifest', writer.manifest_paths.first }
  end
end