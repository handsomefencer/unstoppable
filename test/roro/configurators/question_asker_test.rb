# frozen_string_literal: true

require 'test_helper'
require 'stringio'

describe 'QuestionAsker' do
  Given(:asker)     { Roro::Configurators::QuestionAsker.new }
  Given(:env_hash)  { read_yaml(stack_path)[:env] }
  Given(:stack)     { 'story/story.yml'}
  Given(:options)   { { storyfile: stack_path } }
  Given(:builder)   { QuestionBuilder.new(options) }
  Given(:question)  { builder.override(:development, env_key, env_value)}
  Given(:env_key)   { :SOME_KEY }
  Given(:env_value) { { :value=>"somevalue", :help=>"some_url"} }

  describe '#override_default(question)' do
    context 'when answer is' do
      context 'not blank' do
        Given { asker.stubs(:ask).returns('new value') }
        # Then  { assert_equal 'new value',  asker.override_default(question) }
      end

      context 'blank' do
        Given { asker.stubs(:ask).returns('').then.returns('another answer') }
        # Then  { assert_equal 'another answer',  asker.override_default(question) }
      end
    end

  end

  describe '#confirm_default' do
    context 'when user' do
      Given(:confirm) { asker.confirm_default(question, 'default value') }
      describe 'accepts default must return y' do
        Given { asker.stubs(:ask).returns('y') }
        Then  { assert_equal 'default value',  confirm }
      end

      describe 'accepts all defaults must return y' do
        Given { asker.stubs(:ask).returns('a') }
        Then  { assert_equal '',  confirm }
      end

      describe 'overrides default must return override' do
        Given { asker.stubs(:ask).returns('n').then.returns('override value') }
        Then  { assert_equal 'override value', confirm }
      end
    end
  end
end
