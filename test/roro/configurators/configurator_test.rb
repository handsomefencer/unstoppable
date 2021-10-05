# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { { stack: stack_path } }
  let(:config)       { subject.new(options) }
  let(:inflections)  { [] }

  let(:with_inflection) { -> (method) {
    assert_inflections(inflections)
    config.send(method.to_s)
  }}

  let(:stub_itinerary) {-> (*i) {
    Roro::Configurators::Configurator
      .any_instance
      .stubs(:itinerary)
      .returns(i.map { |i| i.nil? ? stack_path : "#{stack_path}/#{i}" }) } }

  context 'without options' do
    let(:options) { {} }

    describe '#initialize' do
      Then { assert_match 'developer_styles', config.stack }
      And  { assert_equal Hash, config.structure.class }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end

    describe '#choose_adventure' do
      Given(:stub_journey) { Thor::Shell::Basic
                .any_instance
                .stubs(:ask)
                .returns(*answers)}

      Given { assert_nil config.validate_stack }

      context 'when fatsufodo' do
        let(:answers) { %w[fatsufodo] }
        context 'when django' do
          Given { answers << 'django' }
          Given { stub_journey }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/django', config.itinerary }
        end

        context 'when wordpress' do
          Given { answers << 'wordpress' }
          Given { stub_journey }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/wordpress', config.itinerary }
        end

        context 'when rails' do
          Given { answers << 'rails' }
          Given { stub_journey }
          Given { config.choose_adventure }
          Then  { assert_file_match_in 'stories/rails', config.itinerary }
        end
      end
    end
  end


  describe '#initialize' do

    context 'with options' do
      Then { assert_match 'stack/valid', config.stack }
    end
  end


  describe '#initialize' do
    context 'without options' do
      When(:options) { {} }
      Then { assert_match 'developer_styles', config.stack }
      And  { assert_equal Hash, config.structure.class }
    end

    context 'with options' do
      Then { assert_match 'stack/valid', config.stack }
    end
  end

  describe '#validate_stack' do
    context 'when stack is' do
      context 'story' do
        When(:stack) { 'story' }
        # Then { assert config.validate_stack }
      end

      context 'stack' do
        When(:stack) { 'stack' }
        # Then { assert config.validate_stack }
      end

      context 'stacks' do
        When(:stack) { 'stacks' }
        # Then { assert config.validate_stack }
      end
    end
  end

  describe '#choose_adventure' do
    before { skip }
    context 'when stack is' do
      context 'story' do
        When(:stack) { 'story' }
        Then { assert config.choose_adventure }
      end

      context 'stack with one inflection' do
        When(:stack) { 'stack/with_one_inflection' }
        Given { inflections << %w[plots story] }
        Then { assert with_inflection['choose_adventure'] }
      end

      context 'stack with inflections' do
        When(:stack) { 'stack/stack' }
        Given { inflections << %w[plots story] }
        Given { inflections << %w[stories story] }
        Then { assert with_inflection['choose_adventure'] }
      end
    end


    context 'when ' do

      # describe '#build_manifest' do
      #   Given { stub_itinerary }
      #   Given { config.build_manifest }
      #   Then  { assert_equal 8, config.manifest.size }
      # end
      #
      # describe '#build_graph' do
      #   Given { config.build_graph }
      #   # Then  { assert_equal config.structure.keys, config.graph.keys }
      #   # And   { assert_equal 2, config.graph[:questions].size }
      #   # And   { assert_equal 3, config.graph[:env][:development].size }
      # end
    end

  end

  describe '#build_manifest' do
    context 'when stack is' do
      context 'story' do
        When(:stack) { 'story' }

        Given { stub_itinerary[nil] }
        Then  { assert_equal [stack_path], config.itinerary }
        Then { assert config.build_manifest }
        # And  { assert_equal 'blah', config.manifest}

      end

    end
  end

  context 'when stack is stack with one inflection' do
    let(:stack) { 'stack/with_one_inflection' }
    Given { inflections << %w[plots story] }
    # Given { with_inflection['choose_adventure']}

    describe '#validate_stack' do
      # Then { assert config.validate_stack }
    end

    describe '#choose_adventure' do
      Given { with_inflection['choose_adventure']}
      # Then { assert_equal 'blah', stack_path }
      # Then  { assert_file_match_in 'plots/story', config.itinerary }
    end

    # describe '#build_manifests' do
    #   When(:stack) { 'stack/with_one_inflection' }
    #
    #   Given { stub_itinerary }
    #   Given { config.build_manifest }
    #   # focus
    #   # Then  { assert_equal 'blah', config.manifest }
    #   # Then  { assert_file_match_in('fatsufodo.yml', config.manifest) }
    # end
  end

  describe '#build_graph()' do
    context 'when single story in manifest and user' do
      let(:stack) { 'story' }
      let(:actual) { config.graph[:env][:development][:SOME_KEY][:value] }
      Given { config
        .stubs(:manifest)
        .returns(["#{stack_path}/#{stack}.yml"]) }


      context 'accepts default' do
        Given { QuestionAsker
                  .any_instance
                  .stubs(:confirm_default)
                  .returns('y') }
        Given { config.build_graph }
        Then { assert_equal 'default value', actual }
      end

      context 'overrides default' do
        Given { QuestionAsker
                  .any_instance
                  .stubs(:confirm_default)
                  .returns('new value') }
        Given { config.build_graph }
        When(:stack) { 'story' }
        Then { assert_equal 'new value', config.graph[:env][:development][:SOME_KEY][:value] }
      end
    end
  end


  # describe '#choose_adventure' do
  #
  #   context 'multiple inflections' do
  #     When(:stack) { 'stack/stack' }
  #     Given { inflections << %w[plots story]}
  #     Given { inflections << %w[stories story]}
  #     # Given { assert_adventure_chosen }
  #     # Then  { assert_file_match_in('plots/story', config.itinerary ) }
  #     # And   { assert_equal 'blah', config.itinerary }
  #   end
  # end
  #
  # describe '#build_manifests' do
  #   When(:stack) { 'stack/with_one_inflection' }
  #   Given { inflections << %w[plots story] }
  #
  #   Given { assert_adventure_chosen }
  #   Given { config.build_manifest }
  #   # Then  { assert_file_match_in('fatsufodo.yml', config.manifest) }
  #   # And   { assert_file_match_in('django.yml', config.manifest) }
  # end
  #
  # describe '#build_actions' do
  #   Given { assert_adventure_chosen }
  #   Given { config.build_manifest }
  #
  #   describe 'actions variable' do
  #     let(:actions) { config.actions }
  #
  #     describe 'must be set' do
  #       Given { config.build_actions }
  #       # Then  { assert_equal Array, actions.class }
  #     end
  #   end
  # end
  # describe '#initialize' do
  #   context 'when options not supplied' do
  #     When(:options) { {} }
  #     Then { assert_match 'roro/catalog', config.stack }
  #   end
  #
  # end
  # let(:assert_adventure_chosen) {
  #   assert_inflections(inflections)
  #   config.choose_adventure }


  # describe '#merge_story' do
  #   before { skip }
  #   Given { config.merge_story(story_file) }
  #   Then  { assert_includes config.story.keys, :env }
  #   And   { assert_includes config.story.keys, :preface }
  #   And   { assert_includes config.story.keys, :questions }
  #
  #   describe 'preface value be a string' do
  #     Then { assert_equal config.story[:preface].class, String }
  #   end
  #
  #   describe 'env value be a hash' do
  #     Then { assert_equal config.story[:env].class, Hash }
  #     And  { assert_equal config.story[:env][:base].class, Hash }
  #   end
  #
  #   describe 'actions value must be an array of strings' do
  #     Then { assert_equal config.story[:actions].class, Array }
  #     And  { assert_equal config.story[:actions].first.class, String }
  #   end
  #
  #   describe 'questions value must be an array of hashes' do
  #     Then { assert_equal config.story[:questions].class, Array }
  #     And  { assert_equal config.story[:questions].first.class, Hash }
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
  #
  # describe '#sanitize(options' do
  #   context 'when key is a string' do
  #     When(:options) { { 'key' => 'value' } }
  #     Then { assert config.options.keys.first.is_a? Symbol }
  #   end
  #
  #   context 'when value is a' do
  #     context 'string' do
  #       When(:options) { { 'key' => 'value' } }
  #       Then { assert config.options.values.first.is_a? Symbol }
  #     end
  #
  #     context 'when value is an array' do
  #       When(:options) { { 'key' => [] } }
  #       Then { assert config.options.values.first.is_a? Array }
  #     end
  #
  #     context 'when value is an array of hashes' do
  #       When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
  #       Then { assert_equal :bar, config.options[:key][0][:foo] }
  #     end
  #   end
  # end
end
