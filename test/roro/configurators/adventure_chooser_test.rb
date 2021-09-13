# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:catalog_root)     { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path)     { "#{catalog_root}/#{catalog}" }
  let(:adventure)        { AdventureChooser.new(catalog_path) }

  context 'when catalog is empty' do
    let(:catalog) { 'empty' }

    Then { assert_equal [], adventure.itinerary }
  end

  context 'when catalog has no inflections' do
    let(:catalog) { 'roro/roro' }

    Then { assert_equal 1, adventure.itinerary.size }
    And  { assert adventure.itinerary.grep(/roro.yml/).any? }
  end

  context 'when catalog has' do
    let(:questions) { [
      %w[roro/plots 4],
      %w[roro/plots/ruby/stories 1],
      %w[roro/plots/ruby/stories/rails/flavors 2],
      %w[roro/plots/ruby/stories/rails/databases 2]
    ] }

    let(:assert_questions_asked) {
      -> (questions) {
        questions.each { |item|
          inflection_path = "#{catalog_root}/#{item[0]}"
          builder = QuestionBuilder.new(inflection: inflection_path)
          question = builder.question
          assert_question_asked(question, item[1])
        }
      }
    }

    context 'multiple inflections' do
      let(:catalog)    { 'roro' }
      Given { assert_questions_asked[questions] }
      Then  { assert adventure.itinerary.grep(/roro.yml/).any? }
      And   { assert adventure.itinerary.grep(/ruby.yml/).any? }
      And   { assert adventure.itinerary.grep(/rails.yml/).any? }
      And   { assert adventure.itinerary.grep(/rails_react.yml/).any? }
      And   { assert adventure.itinerary.grep(/postgres.yml/).any? }
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
  # end
end
