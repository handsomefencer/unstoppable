# frozen_string_literal: true

require 'test_helper'

describe 'Configurators::Utilities' do
  describe '#stack_type(stack_path)' do
    let(:result) { stack_type(stack_path) }

    context 'when dotfile' do
      When(:stack) { 'story/.keep' }
      Then { assert_equal :dotfile, result}
    end

    context 'when storyfile' do
      When(:stack) { 'stack/story/story.yml' }
      Then { assert_equal :storyfile, result}
    end

    context 'when templates' do
      When(:stack) { 'stack/story/templates' }
      Then { assert_equal :templates, result}
    end

    context 'when inflection' do
      When(:stack) { 'stack/inflection' }
      Then { assert_equal :inflection, result}
    end

    context 'when story' do
      When(:stack) { 'stack/story' }
      Then { assert_equal :story, result}
    end

    context 'when stack' do
      context 'has story, inflection and stack' do
        When(:stack) { 'stack' }
        Then { assert_equal :stack, result}
      end

      context 'has story' do
        When(:stack) { 'stack/stack' }
        Then { assert_equal :stack, result}
      end
    end
  end

  describe '#stack_is_file?' do
    let(:result) { stack_is_file?(stack_path) }

    context 'when stack is a dotfile' do
      When(:stack) { 'story/.keep' }
      Then { assert result }
    end

    context 'when stack is a story file' do
      When(:stack) { 'stacks/story/story.yml' }
      Then { refute result }
    end
  end

  describe '#stack_is_dotfile?' do
    let(:result) { stack_is_dotfile?(stack_path) }

    context 'when stack is a dotfile' do
      When(:stack) { 'story/.keep' }
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
      When(:stack) { 'stack/story/story.yml' }
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
      When(:stack) { 'story/.keep' }
      Then { refute result }
    end
  end

  describe '#all_inflections' do
    let(:inflections) { all_inflections(stack_path) }

    context 'when stack has one inflection' do
      When(:stack) { 'stack' }
      Then { assert_file_match_in('stack/inflection', inflections) }
    end

    context 'when stack has two inflections' do
      When(:stack) { 'stack/stack' }
      Then { assert_file_match_in('stack/plots', inflections) }
      And  { assert_file_match_in('stack/stories', inflections) }
    end

    context 'when stack is a story file' do
      When(:stack) { 'stack/story/story.yml' }
      Then { assert_empty inflections }
    end

    context 'when stack is a story path' do
      When(:stack) { 'stack/story' }
      Then { assert_empty inflections }
    end

    context 'when stack is a template' do
      When(:stack) { 'stack/story/templates' }
      Then { assert_empty inflections }
    end
  end

  describe '#get_children(stack)' do
    let(:children) { get_children(stack_path) }

    context 'when directory has a file and a templates folder' do
      When(:stack) { 'stack/story'}
      Then { assert_equal 2, children.size }
    end

    context 'when directory has several folders' do
      When(:stack) { 'stack'}
      Then { assert_equal 4, children.size }
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
