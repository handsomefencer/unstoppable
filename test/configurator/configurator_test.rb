# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurator::Configurator do
  ## Omakase needs to handle everything that is default. Okanomi handles
  ## everything that is configured via a) config file or b) interrogation.
  before { skip }
  Given { greenfield_rails_test_base }

  Given(:config) { Roro::Configurator::Configurator.new(options) }

  describe 'story when' do
    Given(:expected) { config.default_story }
    Given(:story)    { config.story }

    describe 'nil' do
      Given(:options) { nil }

      Then { assert_equal expected, story }
      And  { refute config.options.keys.include? :greenfield }
    end

    describe 'contains arrays' do
      Given(:options) do
          { story: { rails: [
            { database: :mysql },
            { ci_cd:    :circleci }
          ] } }
        end

      Then { assert_equal options, story }

      describe '.structure' do
        Given(:env)       { config.env }
        Given(:structure) { config.structure }
        Given(:choices)   { config.structure[:choices] }
        Given(:base_keys) do
          %i[
            choices deployment env_vars registries
          ]
        end
        Given(:rails_keys) { %i[story intentions] }
        Given(:base_choices) do
          %i[
            copy_dockerignore backup_existing_files generate_config
          ]
        end
        Given(:rails_choices) do
          %i[
            backup_existing_files config_std_out_true
            copy_dockerignore gitignore_sensitive_files
            insert_hfci_gem_into_gemfile insert_roro_gem_into_gemfile
          ]
        end

        describe 'base (stories.yml) keys and choices present' do
          # Then { base_keys.each { |k| assert_includes structure.keys, k } }
          # And  { choices.each_key { |k| assert_includes choices.keys, k } }
        end

        describe 'rails story keys and choices present' do
          # Then { rails_choices.each { |k| assert_includes choices, k } }
        end

        describe 'intentions must have default values' do
          Given(:choices)    { config.structure[:choices] }
          Given(:intentions) { config.structure[:intentions] }

          # Then { intentions.each { |k, _v| assert_includes choices.keys, k } }
          # And  { intentions.each { |k, v| assert_equal choices[k][:default], v } }
        end

        describe '.env' do
          describe 'dynamic variables' do
            Given(:expected) { %i[main_app_name ruby_version] }

            # Then { expected.each { |e| assert_includes config.env.keys, e } }
            # And  { assert_equal 'omakase', config.env[:main_app_name] }
            # And  { assert_match(/\d.\d./, config.env[:ruby_version]) }
          end

          describe 'story specific variables' do
            Given(:options) do
              { story: { rails: [
                { database: db },
                { ci_cd: { circleci: {} } }
              ] } }
            end

            describe 'must not add mysql env vars to pg story' do \
              Given(:db) { { postgresql: {} } }
              Given { config }

              # Then { assert_includes config.env, :postgres_password }
              # And  { refute config.env.include? :mysql_password }
            end

            describe 'will not add pg env vars to myql story' do
              Given(:db) { { mysql: {} } }
              Given { config }

              # Then { assert_includes config.env, :mysql_password }
              # And  { refute config.env.include? :postgres_password }
            end
          end
        end
      end
    end
  end
end
