# frozen_string_literal: true

require 'test_helper'
require 'stringio'

describe QuestionAsker do
  let(:builder)  { QuestionAsker.new }
  let(:env_hash) { read_yaml(stack_path)[:env] }

  describe '#accept_default' do
    let(:env_key)   { :SOME_KEY }
    let(:env_value) { { :value=>"somevalue", :help=>"some_url"} }
    let(:question)  { builder.override(env_key, env_value).first}
    # let(:question) do
    #   builder = QuestionBuilder.new
    #   result)   { builder.build_overrides_from_storyfile }
    # end
    #
    Then { assert_equal 'blah', question}
  end
end
