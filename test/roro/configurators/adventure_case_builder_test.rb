# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { 'roro'}
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder) { AdventureCaseBuilder.new }

  describe '#all_inflections' do
    let(:inflections) { case_builder.all_inflections(catalog_path) }

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

  describe '#catalog_is_parent' do
    let(:result) { case_builder.catalog_is_parent?(catalog_path) }

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

  describe '#build_paths(catalog)' do
    let(:build_paths) { case_builder.build_paths(catalog_path) }

    context 'when catalog' do
      context 'has one path must return that path' do
        When(:catalog) { 'roro/k8s' }
        Then { assert_file_match_in(catalog, build_paths) }
      end

      context 'is a story file must return empty array' do
        When(:catalog) { 'roro/k8s/k8s.yml' }
        Then { assert_empty build_paths }
      end

      context 'is a template folder must return empty array' do
        When(:catalog) { 'roro/docker_compose/templates' }
        Then { assert_empty build_paths }
      end

      context 'has two child paths must return an array' do
        let(:catalog) { 'roro/plots/python' }

        describe 'with two paths' do
          Then { assert_equal 2, build_paths.size }
        end

        describe 'including correct first path' do
          When(:expected) { 'roro/plots/python/plots/django'}
          Then { assert_file_match_in(catalog, build_paths) }
        end

        describe 'including correct second path' do
          When(:expected) { 'roro/plots/python/plots/flask'}
          Then { assert_file_match_in(catalog, build_paths) }
        end
      end

      context 'has two inflections must return an array' do
        let(:catalog) { 'roro/plots/ruby' }

        describe 'with correct number of possible paths' do
          Then { assert_equal 6, build_paths.size }
        end
      end
    end
  end

  describe '#build_itineraries' do
    let(:itineraries) { case_builder.build_itineraries(catalog_path) }

    context 'when catalog contains' do
      context 'one inflection when first inflection has' do
        let(:catalog) { 'roro/plots/python' }

        context 'a parent with two story paths' do
          describe 'must return two cases' do
            Then { assert_equal 2, itineraries.size }
          end

          describe 'must return correct first case' do
            When(:story)     { 'roro/plots/python/stories/flask'}
            Then { assert_file_match_in(story, itineraries[0]) }
          end

          describe 'must return correct last case' do
            When(:story)     { 'roro/plots/python/stories/django'}
            Then { assert_file_match_in(story, itineraries[-1]) }
          end
        end
      end

      context 'a parent with two inflections' do
        let(:catalog) { 'roro/plots/ruby/stories/rails' }

        describe 'must return 6 inflections' do
          Then { assert_equal 6, itineraries.size }
        end

        describe 'must return correct first inflection' do
          When(:itinerary) { itineraries.first }
          Then { assert_file_match_in('rails/flavors/rails_vue', itineraries[0]) }
          And  { assert_file_match_in('rails/databases/postgres', itineraries[0]) }
        end

        describe 'must return correct last inflection' do
          Then { assert_file_match_in('rails/flavors/rails', itineraries[-1]) }
          And  { assert_file_match_in('rails/databases/mysql', itineraries[-1]) }
        end
      end

      context 'nested inflections' do
        let(:catalog) { 'roro' }

        describe 'must return 11 itineraries' do
          Then { assert_equal 11, itineraries.size }
        end

        describe 'must return correct first inflection' do
          When(:itinerary) { itineraries.first }
          Then { assert_file_match_in('roro/plots/node', itineraries[0]) }
        end

        describe 'must return correct last inflection' do
          Then { assert_file_match_in('rails/flavors/rails', itineraries[-1]) }
          And  { assert_file_match_in('rails/databases/mysql', itineraries[-1]) }
        end
      end
    end
  end
end
