# frozen_string_literal: true

require 'test_helper'

describe 'Configurators::Utilities' do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }

  describe '#build_paths(catalog)' do
    let(:paths) { build_paths(catalog_path) }

    context 'when catalog' do
      context 'has one path must return that path' do
        When(:catalog) { 'roro/k8s' }
        Then { assert_file_match_in(catalog, paths) }
      end

      context 'is a story file must return empty array' do
        When(:catalog) { 'roro/k8s/k8s.yml' }
        Then { assert_empty paths }
      end

      context 'is a template folder must return empty array' do
        When(:catalog) { 'roro/docker_compose/templates' }
        Then { assert_empty paths }
      end

      context 'has two child paths must return an array' do
        let(:catalog) { 'roro/plots/python' }

        describe 'with two paths' do
          Then { assert_equal 2, paths.size }
        end

        describe 'including correct first path' do
          When(:expected) { 'roro/plots/python/plots/django'}
          Then { assert_file_match_in(catalog, paths) }
        end

        describe 'including correct second path' do
          When(:expected) { 'roro/plots/python/plots/flask'}
          Then { assert_file_match_in(catalog, paths) }
        end
      end

      context 'has two inflections must return an array' do
        let(:catalog) { 'roro/plots/ruby' }

        describe 'with correct number of possible paths' do
          Then { assert_equal 6, paths.size }
        end
      end
    end
  end

  describe '#catalog_is_parent' do
    let(:result) { catalog_is_parent?(catalog_path) }

    context 'when catalog is parent' do
      When(:catalog) { 'roro'}
      Then { assert result }
    end

    context 'when catalog is story path' do
      When(:catalog) { 'roro/roro'}
      Then { refute result }
    end

    context 'when catalog is story file' do
      When(:catalog) { 'roro/roro/roro.yml'}
      Then { refute result }
    end

    context 'when catalog is inflection' do
      When(:catalog) { 'roro/plots'}
      Then { refute result }
    end
  end

  describe '#catalog_is_story_path?(catalog)' do
    let(:result) { catalog_is_story_path?(catalog_path) }

    context 'when catalog is' do
      context 'a correct path' do
        When(:catalog) { 'roro/k8s' }
        Then { assert result }
      end

      context 'a story file' do
        When(:catalog) { 'roro/k8s/k8s.yml' }
        Then { refute result }
      end

      context 'an inflection' do
        When(:catalog) { 'roro/plots' }
        Then { refute result }
      end

      context 'a template' do
        When(:catalog) { 'roro/plots' }
        Then { refute result }
      end
    end
  end

  describe '#all_inflections' do
    let(:inflections) { all_inflections(catalog_path) }

    context 'when catalog is a parent with one inflection' do
      When(:catalog) { 'roro/plots/python' }
      Then { assert_file_match_in('python/stories', inflections) }
    end

    context 'when catalog is a parent with two inflections' do
      When(:catalog) { 'roro/plots/ruby/stories/rails' }
      Then { assert_file_match_in('rails/flavors', inflections) }
      And  { assert_file_match_in('rails/databases', inflections) }
    end

    context 'when catalog is a story file' do
      When(:catalog) { 'roro/roro/roro.yml' }
      Then { assert_empty inflections }
    end

    context 'when catalog is a story path' do
      When(:catalog) { 'roro/roro' }
      Then { assert_empty inflections }
    end

    context 'when catalog is a template' do
      When(:catalog) { 'roro/docker_compose/templates' }
      Then { assert_empty inflections }
    end
  end

  describe '#get_children(catalog)' do
    let(:execute) { get_children(catalog_path) }
    let(:child)   { -> (child) { "#{catalog}/#{child}" } }

    context 'when directory has one file' do
      When(:catalog) { '/inflection/docker_compose'}
      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has one folder' do
      When(:catalog) { '/inflection'}
      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has several folders' do
      When(:catalog) { 'roro'}
      Then { assert_equal 5, execute.size }
    end
  end

  describe '#sanitize(hash)' do
    context 'when key is a string' do
      When(:options) { { 'key' => 'value' } }
      Then { assert sanitize(options).keys.first.is_a? Symbol }
    end

    context 'when value is a' do
      context 'string' do
        When(:options) { { 'key' => 'value' } }
        Then { assert sanitize(options).values.first.is_a? Symbol }
      end

      context 'array' do
        When(:options) { { 'key' => [] } }
        Then { assert sanitize(options).values.first.is_a? Array }
      end

      context 'array of hashes' do
        When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
        Then { assert_equal :bar, sanitize(options)[:key][0][:foo] }
      end
    end
  end

  describe '#sentence_from' do
    let(:call) { -> (array) { sentence_from(array) } }

    Then { assert_equal 'one, two and three', call[%w[one two three]] }
    And  { assert_equal 'one and two', call[%w[one two]] }
    And  { assert_equal 'one', call[%w[one]] }
  end
end
