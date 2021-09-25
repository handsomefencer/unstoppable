# frozen_string_literal: true

require 'test_helper'

describe 'Configurators::Utilities' do
  describe '#stackable_type(stack_path' do
    let(:result) { stack_type(stack_path) }

    context 'when file' do
      When(:result) { stack_type(stack_path(:invalid)) }
      When(:stack)  { 'ruby.rb' }
      Then { assert_equal :file, result}
    end

    context 'when dotfile' do
      When(:stack)  { '.keep' }
      Then { assert_equal :dotfile, result}
    end

    context 'when storyfile' do
      When(:stack)  { 'stacks_1/stack_1/stack_1.yml' }
      Then { assert_equal :storyfile, result}
    end

    context 'when templates' do
      When(:stack)  { 'stacks_1/stack_1/templates' }
      Then { assert_equal :templates, result}
    end

    context 'when inflection' do
      When(:stack)  { 'stacks_1' }
      Then { assert_equal :inflection, result}
    end

    context 'when story' do
      context 'simple story' do
        When(:stack)  { 'stacks_1/stack_1' }
        Then { assert_equal :story, result}
      end

      context 'nested story' do
        before { skip }
        When(:stack)  { 'stacks_1/stack_2' }

        Then { assert_equal :story, result}
      end
    end

    context 'when empty' do
      When(:stack)  { 'stacks_1/stack_1' }
      Then { assert_equal :story, result}
    end
  end

  describe '#stack_is_file?' do
    let(:result) { stack_is_file?(stack_path) }

    context 'when stack is a dotfile' do
      When(:stack) { '.keep' }
      Then { assert result }
    end

    context 'when stack is a story file' do
      When(:stack) { 'stacks_1/stack_1/stack_1.yml' }
      Then { assert result }
    end
  end

  describe '#stack_is_dotfile?' do
    let(:result) { stack_is_dotfile?(stack_path) }

    context 'when stack is a dotfile' do
      When(:stack) { '.keep' }
      Then { assert result }
    end

    context 'when stack is a story file' do
      When(:stack) { 'stacks_1/stack_1/stack_1.yml' }
      Then { refute result }
    end
  end

  describe '#stack_is_story_file?' do
    let(:result) { stack_is_storyfile?(stack_path) }

    context 'when stack is a story file' do
      When(:stack) { 'stacks_1/stack_1/stack_1.yml' }
      Then { assert result }
    end

    context 'when stack is a dotfile' do
      When(:stack) { '.keep' }
      Then { refute result }
    end
  end

  describe '#stack_is_inflection?' do
    let(:result) { stack_is_inflection?(stack_path) }

    context 'when stack is an inflection' do
      When(:stack) { 'stacks_1' }
      Then { assert result }
    end

    context 'when stack is a dotfile' do
      When(:stack) { '.keep' }
      # Then { refute result }
    end
  end



  # describe '#stack_is_stack?' do
  #   let(:result) { stack_is_story_file?(stack_path) }
  #
  #   context 'when stack is a story file' do
  #     When(:stack) { 'stacks_1/stack_1/stack_1.yml' }
  #     Then { assert result }
  #   end
  #
  #   context 'when stack is a dotfile' do
  #     When(:stack) { '.keep' }
  #     Then { refute result }
  #   end
  # end

  # describe '#stack_is_story?' do
  #   let(:result) { stack_is_story_file?(stack_path) }
  #
  #   context 'when stack is a story file' do
  #     When(:stack) { 'stacks_1/stack_1/stack_1.yml' }
  #     Then { assert result }
  #   end
  #
  #   context 'when stack is a dotfile' do
  #     When(:stack) { '.keep' }
  #     Then { refute result }
  #   end
  # end
  #



  describe '#stack_is_parent' do
    before { skip }
    let(:result) { stack_is_parent?(stack_path) }

    context 'when stack is parent' do
      # When(:stack) { 'roro'}
      Then { assert_equal 'blah', stack_path }
      # Then { assert result }
    end

    context 'when stack is story path' do
      When(:stack) { 'roro/roro'}
      Then { refute result }
    end

    context 'when stack is story file' do
      When(:stack) { 'roro/roro/roro.yml'}
      Then { refute result }
    end

    context 'when stack is inflection' do
      When(:stack) { 'roro/plots'}
      Then { refute result }
    end
  end

  describe '#stack_is_story_path?(stack)' do
    before { skip }
    let(:result) { stack_is_story_path?(stack_path) }

    context 'when stack is' do
      context 'a correct path' do
        When(:stack) { 'roro/k8s' }
        Then { assert result }
      end

      context 'a story file' do
        When(:stack) { 'roro/k8s/k8s.yml' }
        Then { refute result }
      end

      context 'an inflection' do
        When(:stack) { 'roro/plots' }
        Then { refute result }
      end

      context 'a template' do
        When(:stack) { 'roro/plots' }
        Then { refute result }
      end
    end
  end

  describe '#all_inflections' do
    before { skip }
    let(:inflections) { all_inflections(stack_path) }

    context 'when stack is a parent with one inflection' do
      When(:stack) { 'roro/plots/python' }
      Then { assert_file_match_in('python/stories', inflections) }
    end

    context 'when stack is a parent with two inflections' do
      When(:stack) { 'roro/plots/ruby/stories/rails' }
      Then { assert_file_match_in('rails/flavors', inflections) }
      And  { assert_file_match_in('rails/databases', inflections) }
    end

    context 'when stack is a story file' do
      When(:stack) { 'roro/roro/roro.yml' }
      Then { assert_empty inflections }
    end

    context 'when stack is a story path' do
      When(:stack) { 'roro/roro' }
      Then { assert_empty inflections }
    end

    context 'when stack is a template' do
      When(:stack) { 'roro/docker_compose/templates' }
      Then { assert_empty inflections }
    end
  end

  describe '#get_children(stack)' do
    before { skip }
    let(:execute) { get_children(stack_path) }
    let(:child)   { -> (child) { "#{stack}/#{child}" } }

    context 'when directory has one file' do
      When(:stack) { '/inflection/docker_compose'}
      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has one folder' do
      When(:stack) { '/inflection'}
      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has several folders' do
      When(:stack) { 'roro'}
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
