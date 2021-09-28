# frozen_string_literal: true

module Minitest
  class Spec

    def stack_path(args = nil )
      append = defined?(stack) ? "/#{stack}" : nil
      prepend_valid = args.eql?(:invalid) ? 'invalid' : 'valid'
      stack_root ||= "#{fixture_path}/stacks/#{prepend_valid}"
      "#{stack_root}#{append}"
    end

    def assert_valid_stack(stack)
      assert_nil validator.validate("#{stack_path}#{"/#{stack}" if stack}")
    end

    def assert_inflections(inflections)
      inflections.each { |item|
        inflection_path = "#{catalog_path}#{"/#{item[0]}" unless item[0].nil?}"
        builder = QuestionBuilder.new(inflection: stack_path)
        builder.build_from_inflection
        question = builder.question
        inflection_options = builder.inflection_options
        assert_question_asked(question, inflection_options.key(item[1])) }
    end
  end
end
