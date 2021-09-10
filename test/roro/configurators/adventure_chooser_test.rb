# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:subject)      { AdventureChooser }
  let(:adventure)    { subject.new(catalog) }
  let(:catalog_root) { "#{Roro::CLI.catalog_root}" }
  let(:catalog)      { "#{Dir.pwd}/test/fixtures/catalogs/structure/#{node}" }

  describe '#itinerary' do
    context 'when catalog is empty' do
      When(:node) { 'empty' }
      Then { assert_equal [], adventure.itinerary }
    end

    context 'when catalog is roro' do
      When(:node) { 'roro' }
      Then { assert_equal 4, adventure.itinerary.size }
    end
  end

  describe '#get_story_preface' do
    let(:preface) { adventure.get_story_preface(catalog) }

    context 'when scene has no plot file' do
      When(:node) { 'roro/k8s/k8s.yml' }
      Then { refute preface }
    end

    context 'when scene has a plot file with a preface' do
      When(:node) { 'roro/roro.yml' }
      Then { assert_match 'Default roro stories', preface }
    end
  end

  describe '#choose_adventure' do
    let(:node)             { inflection }
    let(:choose_adventure) { adventure.choose_adventure(inflection) }
    let(:question_prompt)  { adventure.build_question_prompt }
    let(:question_options) { adventure.build_question_options }
    let(:question) { adventure.build_question }
    let(:choose_adventure) { adventure.choose_adventure(catalog) }

    context 'when parent is roro and inflection is plots' do
      let(:inflection)     { 'roro/plots' }

      before { choose_adventure }

      describe '#build_question_prompt' do
        Then { assert_match 'choose from these roro plots',  question_prompt }
      end

      describe '#build_question_options' do
        Then { assert_equal question_options.size, 4 }
        And  { assert_includes question_options.values, 'php' }
        And  { assert_includes question_options.values, 'ruby' }
        And  { assert_includes question_options.values, 'node' }
      end

      describe '#build_question' do
        Then { assert_match 'choose from these roro plots',  question.first }
        And  { assert_equal Hash, question.last.class }
      end
    end

    context 'when parent is ruby and inflection is stories' do
      let(:inflection) { 'roro/plots/ruby/stories' }

      before { choose_adventure }

      describe '#build_question_prompt' do
        Then { assert_includes question_prompt, 'choose from these ruby stories' }
      end

      describe '#build_question_options' do
        Then { assert_equal 2, question_options.count }
        And  { assert_equal String, question_options.keys.first.class }
      end
    end

    context 'when parent is rails and inflection is stories' do
      let(:inflection) { 'roro/plots/ruby/stories/rails/flavors' }

      before { choose_adventure }

      describe '#build_question_prompt' do
        Then { assert_includes question_prompt, 'choose from these rails flavors' }
      end

      describe '#build_question_options' do
        Then { assert_includes question_options.values, 'rails' }
        And  { assert_includes question_options.values, 'rails_vue' }
        And  { assert_includes question_options.values, 'rails_react' }
      end
    end
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
  # end

end
