# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:adventure)    { AdventureChooser.new(catalog_path) }
  let(:catalog)      { 'roro' }

  describe '#itinerary' do
    context 'when catalog is empty' do
      When(:catalog) { 'empty' }
      Then { assert_equal [], adventure.itinerary }
    end

    context 'when catalog has just one story roro/roro' do
      When(:catalog) { 'roro/roro' }
      Then { assert_equal 1, adventure.itinerary.size }
      And  { assert_match 'roro/roro/roro.yml', adventure.itinerary.first }
    end
  end

  describe '#choose_adventure' do
    let(:inflection_path)  { "#{catalog_root}/#{inflection}" }
    let(:choose_adventure) { adventure.choose_adventure(inflection_path) }
    let(:question_builder) { QuestionBuilder.new(inflection: inflection_path) }
    let(:question)         { question_builder.question }
    let(:answer)

    context 'when one inflection in path' do
      context 'rails_react' do
        When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
        Given { assert_question_asked(question, '2') }
        Then { assert_match 'rails_react/rails_react.yml', choose_adventure }
      end

      context 'rails_vue' do
        When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
        Then { assert_question_asked(question, '3') }
        And  { assert_match 'rails_vue/rails_vue.yml', choose_adventure }
      end

      context 'rails' do
        When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
        Then { assert_question_asked(question, '1') }
        And  { assert_match 'rails/rails.yml', choose_adventure }
      end
    end

    context 'when two inflections in path' do
      context 'rails' do
        When(:inflection) { 'roro/plots/ruby/stories' }
        Then { assert_question_asked(question, '1') }
        And  { assert_match 'rails/rails.yml', choose_adventure }
      end

      context 'ruby_gem' do
        When(:inflection) { 'roro/plots/ruby/stories' }
        Then { assert_question_asked(question, '2') }
        And  { assert_match 'ruby_gem/ruby_gem.yml', choose_adventure }
      end
    end

    context 'when three inflections in path' do
      context 'node' do
        When(:inflection) { 'roro/plots' }
        Then { assert_question_asked(question, '1') }
        And  { assert_match 'node/node.yml', choose_adventure }
      end

      context 'php' do
        When(:inflection) { 'roro/plots' }
        Then { assert_question_asked(question, '2') }
        And  { assert_match 'php/php.yml', choose_adventure }
      end

      context 'python' do
        When(:inflection) { 'roro/plots' }
        Then { assert_question_asked(question, '3') }
        And  { assert_match 'python/python.yml', choose_adventure }
      end

      context 'ruby' do
        When(:inflection) { 'roro/plots' }
        Then { assert_question_asked(question, '4') }
        And  { assert_match 'ruby/ruby.yml', choose_adventure }
      end
    end

  # describe '#choose_env_var' do
  #   let(:scene)    { "#{catalog_root}/plots/ruby" }
  #   let(:question) { config.get_plot(scene)[:questions][0] }
  #   let(:command)  { config.choose_env_var(question) }
  #   let(:prompt)   { question[:question] }
  #   let(:answer)   { 'schadenfred' }
  #
  #   Given do
  #     Thor::Shell::Basic.any_instance
  #                       .stubs(:ask)
  #                       .with(prompt)
  #                       .returns(answer)
  #   end
  #
  #   Given { command }
  #   # Then  { assert_includes config.env[:docker_username], 'schadenfred' }
  # end
  #
  # describe '#write_adventure' do
  #   let(:scene) { catalog_root }
  #   let(:story) { { roro: {} } }
  #
  #   Given do
  #     Roro::Configurators::Omakase
  #       .any_instance
  #       .stubs(:story)
  #       .returns(story)
  #   end
  #
  #   # Then { assert_equal config.story, story }
  end
end
