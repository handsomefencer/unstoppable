# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:catalog_root)     { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path)     { "#{catalog_root}/#{catalog}" }
  let(:inflection_path)  { "#{catalog_root}/#{catalog}/#{inflection}" }
  let(:adventure)        { AdventureChooser.new(catalog_path) }
  let(:question_builder) { QuestionBuilder.new(inflection: inflection_path) }
  let(:question)         { question_builder.question }

  context 'when catalog is empty' do
    let (:catalog) { 'empty' }

    Then { assert_equal [], adventure.itinerary }
  end

  context 'when catalog has no inflections' do
    let(:catalog) { 'roro/roro' }

    Then { assert_equal 1, adventure.itinerary.size }
    And  { assert adventure.itinerary.grep(/roro.yml/).any? }
  end

  context 'when catalog has inflections' do
    let(:catalog)    { 'roro' }
    let(:inflection) { 'plots' }

    Given { assert_question_asked(question, '1')}
    Then  { assert_includes adventure.itinerary, 'blah' }
  end

  # let(:answers) { -> (catalog_path, choice, story) {
  #   assert_question_asked(question, choice)
  # } }
  #

  # describe '#build_itinerary' do
  #   let(:expected) { "#{catalog_path}/#{story}"}
  #
  #   context 'when catalog is empty must return empty' do
  #     When(:catalog) { 'empty' }
  #     Then { assert_equal [], adventure.itinerary }
  #   end
  #
  #   context 'when catalog has one story must return array with one' do
  #     When(:story)   { 'roro.yml' }
  #     When(:catalog) { 'roro/roro' }
  #     Then { assert_includes adventure.itinerary, expected }
  #   end
  #
  #   context 'when catalog is complex must return all stories' do
  #     When(:story)   { 'rails.yml' }
  #     When(:catalog) { 'roro' }
  #     focus
  #     Then { assert_includes adventure.itinerary, expected }
  #   end
  # end
  #
  # describe '#choose_adventure' do
  #
  #   context 'when one inflection in path' do
  #     let(:answers) { -> (path, choice, story) {
  #       assert_question_asked(question, choice)
  #       assert_match "#{story}/#{story}.yml", choose_adventure
  #     } }
  #
  #     context 'rails_react' do
  #       When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
  #       Given { assert_question_asked(question, '2') }
  #       Then { assert_match 'rails_react/rails_react.yml', choose_adventure }
  #       And { answers[inflection_path, '2', 'rails_react'] }
  #     end
  #
  #     context 'rails_vue' do
  #       When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
  #       Then { assert_question_asked(question, '3') }
  #       And  { assert_match 'rails_vue/rails_vue.yml', choose_adventure }
  #     end
  #
  #     context 'rails' do
  #       When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }
  #       Then { assert_question_asked(question, '1') }
  #       And  { assert_match 'rails/rails.yml', choose_adventure }
  #     end
  #   end
  #
  #   context 'when two inflections in path' do
  #     context 'rails' do
  #       When(:inflection) { 'roro/plots/ruby/stories' }
  #       Then { assert_question_asked(question, '1') }
  #       And  { assert_match 'rails/rails.yml', choose_adventure }
  #     end
  #
  #     context 'ruby_gem' do
  #       When(:inflection) { 'roro/plots/ruby/stories' }
  #       Then { assert_question_asked(question, '2') }
  #       And  { assert_match 'ruby_gem/ruby_gem.yml', choose_adventure }
  #     end
  #   end
  #
  #   context 'when three inflections in path' do
  #     context 'node' do
  #       When(:inflection) { 'roro/plots' }
  #       Then { assert_question_asked(question, '1') }
  #       And  { assert_match 'node/node.yml', choose_adventure }
  #     end
  #
  #     context 'php' do
  #       When(:inflection) { 'roro/plots' }
  #       Then { assert_question_asked(question, '2') }
  #       And  { assert_match 'php/php.yml', choose_adventure }
  #     end
  #
  #     context 'python' do
  #       When(:inflection) { 'roro/plots' }
  #       Then { assert_question_asked(question, '3') }
  #       And  { assert_match 'python/python.yml', choose_adventure }
  #     end
  #
  #     context 'ruby' do
  #       When(:inflection) { 'roro/plots' }
  #       Then { assert_question_asked(question, '4') }
  #       And  { assert_match 'ruby/ruby.yml', choose_adventure }
  #     end
  #   end

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
  # end
end
