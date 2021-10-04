# frozen_string_literal: true

require 'test_helper'
require 'stringio'

describe QuestionAsker do
  let(:asker)  { QuestionAsker.new }
  let(:env_hash) { read_yaml(stack_path)[:env] }
  let(:stack)     { 'story/story.yml'}
  let(:options)   { { storyfile: stack_path } }
  let(:builder)   { QuestionBuilder.new(options) }
  let(:question)  { builder.override(:development, env_key, env_value)}
  let(:env_key)   { :SOME_KEY }
  let(:env_value) { { :value=>"somevalue", :help=>"some_url"} }

  describe '#override_default(question)' do
    context 'when answer is' do
      context 'not blank' do
        Given { asker.stubs(:ask).returns('new value') }
        Then  { assert_equal 'new value',  asker.override_default(question) }
      end

      context 'blank' do
        Given { asker.stubs(:ask).returns('').then.returns('another answer') }
        Then  { assert_equal 'another answer',  asker.override_default(question) }
      end
    end

  end

  describe '#confirm_default' do
    context 'when user' do
      context 'accepts default must return default' do
        Given { stubs_asker }
        Then  { assert_equal 'y',  asker.confirm_default(question) }
      end

      context 'overrides default must return override' do
        Given { asker.stubs(:ask).returns('n').then.returns('new value') }
        Then  { assert_equal 'new value', asker.confirm_default(question) }
      end
    end
  end
end
