# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        @cases =  {}
      end

      def build_cases(stack = nil, cases = {})
        stack ||= @stack
        case
        when stack_type(stack).eql?(:templates)
          return
        when stack_type(stack_parent_path(stack)).eql?(:inflection) && [:stack, :story].include?(stack_type(stack))
          cases[name(stack).to_sym] = {}
          cases = cases[name(stack).to_sym]
        end
        children(stack).each do |c|
          build_cases(c, cases)
        end
        @cases = cases
      end

      def document_cases
        File.open("#{Dir.pwd}/test/helpers/adventure_cases.yml", "w") { |f| f.write(cases.to_yaml) }
      end

      def case_from_path(stack, array = nil)
        array ||= stack.split("#{@stack}/").last.split('/') unless @case
        folder = array.shift
        stack = "#{@case ? stack : @stack}/#{folder}"
        (@case ||= [])
        @case << folder if stack_is_adventure?(stack)
        case_from_path(stack, array) unless array.empty?
        @case
      end
    end
  end
end
