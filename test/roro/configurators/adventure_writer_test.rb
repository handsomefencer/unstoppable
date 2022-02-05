# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given(:workbench) { }
  Given(:writer)    { AdventureWriter.new }

  Given { writer.instance_variable_set(:@env, buildenv[:env]) }
  Given { writer.instance_variable_set(:@storyfile, storyfile) }

  Given(:buildenv)  { { env: { base: {
    db_pkg: { value: 'sqlite' },
    db_vendor: { value: 'sqlite' },
    ruby_version: { value: '3.0' } } } } }

  Given(:base) { "#{Roro::CLI.stacks}/unstoppable_developer_styles/okonomi" }
  Given(:storyfile) { [base, story].join('/') }

  context 'django' do
    Given(:story) { "languages/python/frameworks/django/django.yml" }

    describe 'must return correct' do
      describe 'number of partials' do
        Then { assert_equal 5, writer.partials.size }
      end

      describe '#partial(name)' do
        Then { assert_equal 'getsome', writer.partial('packages') }
      end

      describe '#section_partial(name)' do
        Then { assert_equal 2, writer.section_partials('services').size }
        Then { assert_match /web/, writer.section_partials('services').first }
        And  { assert_match /db/, writer.section_partials('services').last }
      end

      describe 'partials' do
        Then { assert_match /_packages/, writer.partials[0]  }
        And  { assert_match /_web/, writer.partials[1]  }
        And  { assert_match /_packages/, writer.partials[2]  }
        And  { assert_match /_db/, writer.partials[3]  }
        And  { assert_match /_web/, writer.partials[4]  }
      end
    end

    describe '#section(name)' do
      context 'when section not present' do
        Then { assert_raises(Roro::Error) { writer.section ('not_present') } }
      end

      describe 'must return interpolation from the most specific partial' do
        Given(:section) { writer.section('services') }
        Then { assert_match 'db', section }
      end
    end

    describe '#select_innermost_partials' do
      # Then { assert_equal 'blah', writer.select_innermost_partials }
    end
  end

  context 'rails' do
    When(:story) { "languages/ruby/frameworks/rails/versions/v6_1/v6_1.yml" }

    describe '#write' do
      Given { writer.write(buildenv, storyfile) }
      # Then  { assert_file 'docker-compose.yml' }
    end

    describe '#partials' do
      describe 'must return an array of ancestor partials' do
        Then { assert_equal Array, writer.partials.class }
      end

      describe 'must return correct number of partials' do
        Then { assert_equal 7, writer.partials.size }
      end
    end

    describe '#partial(name)' do
      describe 'must return interpolation from the most specific partial' do
        Given(:partials) { writer.partials }

        context 'when variable missing' do
          Given(:buildenv)  { { env: { } } }
          Then { assert_raises(Roro::Error) { writer.partial('packages') } }
        end

        context 'when variable present' do
          Then { assert_match 'sqlite', writer.partial('packages') }
        end
      end
    end

    describe '#manifest_paths' do
      Then { assert_match 'templates/manifest', writer.manifest_paths.first }
    end
  end
end
