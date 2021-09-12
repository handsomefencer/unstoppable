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

    context 'when catalog is roro/roro' do
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
      When(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }

      Then {
        assert_question_asked(question, '2')
        assert_equal "#{inflection}/rails_react", choose_adventure
      }
      # assert_equal 'dd', choose_adventure
      # assert_equal question, 'blah'
    end



    # describe '#choose_your_adventure' do
  #   let(:question) { "Please choose from these #{collection}:" }
  #   let(:choices)  { plots.sort.map.with_index { |x, i| [i + 1, x] }.to_h }
  #   let(:prompt)   { "#{question} #{choices}" }
  #   let(:command) { config.choose_plot(scene) }
  #
  #   def assert_plot_chosen(collection, plots, plot)
  #     question = "Please choose from these #{collection}:"
  #     choices = plots.sort.map.with_index { |x, i| [i + 1, x] }.to_h
  #     prompt = "#{question} #{choices}"
  #     assert_asked(prompt, choices, plot)
  #   end
  #
  #   let(:acts) do
  #     [
  #       ['roro plots', %w[node php python ruby], 4],
  #       ['ruby plots', %w[rails ruby_gem], 1],
  #       ['rails plots', %w[rails rails_react rails_vue], 2]
  #     ]
  #   end
  #
  #   describe '#choose_your_adventure' do
  #     let(:command) { config.choose_your_adventure(scene) }
  #
  #     # Then do
  #     #   acts.each { |act| assert_plot_chosen(*act) }
  #     #   command
  #     #   assert_equal({ ruby: { rails: { rails_react: {} } } }, config.story)
  #     # end
  #   end
  #
  #   describe '#choose_plot' do
  #     let(:command) { config.choose_plot(scene) }
  #
  #     context 'from lib/roro/library/plots' do
  #       # Then do
  #       #   assert_plot_chosen(*acts[0])
  #       #   command
  #       # end
  #     end
  #
  #     context 'ruby plots' do
  #       let(:scene) { "#{catalog_root}/roro/plots/ruby/plots" }
  #
  #       # Then do
  #       #   assert_plot_chosen(*acts[1])
  #       #   command
  #       # end
  #     end
  #
  #     context 'from lib/roro/library/plots/ruby/plots/rails/plots' do
  #       let(:scene) { "#{catalog_root}/plots/ruby/plots/rails/plots" }
  #
  #       # Then do
  #       #   assert_plot_chosen(*acts[2])
  #       #   command
  #       # end
  #     end
  #
  #     context 'from lib/roro/library/databases' do
  #       let(:scene)      { "#{catalog_root}/roro/plots/ruby/plots/rails/databases" }
  #       let(:collection) { 'rails databases' }
  #       let(:plots)      { %w[mysql postgres] }
  #       let(:choice)     { { 1 => 'mysql' } }
  #
  #       # Then { assert_asked(prompt, choices, choice.keys.first) }
  #       # And  { assert_equal choice.values.first, command }
  #     end
  #   end
  # end
  #
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
