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
  end
end
