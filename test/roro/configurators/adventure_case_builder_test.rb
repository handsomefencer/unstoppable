# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { 'roro'}
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder) { AdventureCaseBuilder.new }

  describe '#catalog_is_story_path?(catalog)' do
    let(:result) { case_builder.catalog_is_story_path?(catalog_path) }

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

  describe '#build_paths(catalog)' do
    let(:result) { case_builder.build_paths(catalog_path) }

    context 'when catalog' do
      context 'has one path must return that path' do
        When(:catalog) { 'roro/k8s' }
        Then { assert_file_match_in(catalog, result) }
      end

      context 'is a story file must return empty array' do
        When(:catalog) { 'roro/k8s/k8s.yml' }
        Then { assert_empty result}
      end

      context 'is a template folder must return empty array' do
        When(:catalog) { 'roro/docker_compose/templates' }
        Then { assert_empty result}
      end

      context 'has two child paths must return an array' do
        let(:catalog) { 'roro/plots/python' }

        describe 'with two paths' do
          Then { assert_equal 2, result.size }
        end

        describe 'including correct first path' do
          When(:expected) { 'roro/plots/python/plots/django'}
          Then { assert_file_match_in(catalog, result) }
        end

        describe 'including correct second path' do
          When(:expected) { 'roro/plots/python/plots/flask'}
          Then { assert_file_match_in(catalog, result) }
        end
      end

      context 'has two inflections must return an array' do
        let(:catalog) { 'roro/plots/ruby' }

        describe 'with correct number of possible paths' do
          Then { assert_equal 6, result.size }
        end
      end
    end
  end

  describe '#build_itineraries' do
    let(:result) { case_builder.build_itineraries(catalog_path) }
    context 'when catalog is not an inflection' do
      When(:catalog) { 'roro/plots/ruby/stories/rails/flavors/rails_vue' }
      Then { assert_equal 1, result.size }
    end

    context 'when catalog is an inflection with' do
      describe 'three inflections' do
        When(:catalog) { 'roro/plots/ruby/stories/rails/flavors' }
        Then { assert_equal 3, result }
      end

      describe 'child inflections' do
        When(:catalog) { 'roro/plots/ruby/stories' }
        Then { assert_equal 3, result }
      end
    end
  end
end


