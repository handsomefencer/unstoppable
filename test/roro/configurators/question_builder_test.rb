# frozen_string_literal: true

require 'test_helper'

describe QuestionBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:builder)      { QuestionBuilder.new(options) }

  describe '#build_from_inflection' do
    let(:inflection_path)  { "#{catalog_root}/#{inflection}" }
    let(:options)          { { inflection: inflection_path } }
    let(:inflection_prompt)  { builder.inflection_prompt }
    let(:inflection_options) { builder.inflection_options }
    let(:inflection)       { 'roro/plots' }

    describe '#inflection_prompt when parent is' do
      context 'roro and inflection is plots' do
        Then { assert_match 'these roro plots',  inflection_prompt }
      end

      context 'ruby and inflection is stories' do
        When(:inflection) { 'roro/plots/ruby/stories' }
        Then { assert_includes inflection_prompt, 'choose from these ruby stories' }
      end

      context 'rails and inflection is flavors' do
        When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
        Then { assert_includes inflection_prompt, 'choose from these rails flavors' }
      end
    end

    describe '#inflection_options when parent is' do
      context 'roro and inflection is plots' do
        Then { assert_equal inflection_options.size, 4 }
        And  { assert_includes inflection_options.values, 'php' }
        And  { assert_includes inflection_options.values, 'ruby' }
        And  { assert_includes inflection_options.values, 'node' }
      end

      context 'ruby and inflection is stories' do
        When(:inflection) { 'roro/plots/ruby/stories' }
        Then { assert_equal 2, inflection_options.count }
        And  { assert_equal String, inflection_options.keys.first.class }
      end

      context 'rails and inflection is flavors' do
        When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
        Then { assert_includes inflection_options.values, 'rails' }
        And  { assert_includes inflection_options.values, 'rails_vue' }
        And  { assert_includes inflection_options.values, 'rails_react' }
      end
    end

    describe '#get_story_preface' do
      let(:story_location) { "#{catalog_root}/#{story}"}
      let(:preface) { builder.get_story_preface(story_location) }

      context 'when story has' do
        context 'a story file' do
          When(:story) { 'roro' }
          Then { assert_match 'share developer stories', preface }
        end

        context 'a nested story file' do
          When(:story) { 'roro/docker_compose' }
          Then { assert_match 'tool for defining and running', preface }
        end

        context 'a story file without a preface' do
          When(:story) { 'roro/k8s' }
          Then { assert_nil preface }
        end
      end
    end

    describe '#promptable_options' do

    end


  end


end
