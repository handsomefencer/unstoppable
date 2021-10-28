# frozen_string_literal: true

require 'test_helper'

describe 'DependencySatisfier' do
  Given(:satisfier)          { DependencySatisfier.new }
  Given(:base_dependencies)  { satisfier.gather_base_dependencies }
  Given(:stack_dependencies) { satisfier.gather_stack_dependencies }
  Given(:dependencies)       { satisfier.dependencies }
  Given(:manifest)           { [] }

  Given { satisfier.satisfy_dependencies(manifest) }

  describe '#satisfy_dependencies(manifest)' do
    context 'when manifest' do
      Given(:manifest) { [stack_path] }
      Given(:stack)    { 'story/story.yml' }

      describe 'is empty must return a hash with base keys' do
        Given(:manifest) { [] }

        Then { assert_includes dependencies.keys, :git }
        And  { assert_includes dependencies.keys, :doctl }
        And  { assert_includes dependencies.keys, :kubectl }
        And  { assert_match dependencies[:git][:command], 'git -v' }
      end

      describe 'has a new stack dependency' do
        Then { assert_includes dependencies.keys, :notional_tool }
        And  { assert_includes dependencies.keys, :git }

      end

      describe 'has an overriding stack dependency' do
        Then { assert_includes dependencies.keys, :git }
        And  { assert_match dependencies[:git][:command], 'git -overridden' }
      end
    end
  end

  describe '#gather_base_dependencies' do
    describe 'must return a hash with expected keys' do
      Then { assert_includes base_dependencies.keys, :git }
      And  { assert_includes base_dependencies[:git].keys, :command }
      And  { assert_includes base_dependencies[:git].keys, :help }
      And  { assert_includes base_dependencies[:git].keys, :name }
    end
  end

  describe '#gather_stack_dependencies' do
    context 'when manifest' do
      describe 'is empty must return empty hash' do
        Then { assert stack_dependencies.empty? }
      end

      context 'has no dependencies' do
        Given(:manifest) { [stack_path] }
        Given(:stack)    { 'story/valid_env.yml' }
        Then { assert stack_dependencies.empty? }
      end

      context 'has dependencies' do
        Given(:manifest) { [stack_path] }
        Given(:stack)    { 'story/story.yml' }
        Then { assert_includes stack_dependencies.keys, :git }
      end
    end
  end
end


