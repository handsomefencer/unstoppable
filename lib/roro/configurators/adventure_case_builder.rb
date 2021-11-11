# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
        @cases =  {}
      end

      def build_cases(stack = nil)
        stack ||= @catalog
        st  = stack_type(stack)
        sp  = stack_parent(stack)
        spt = stack_type(stack_parent_path(stack))
        case
        when stack_type(stack_parent_path(stack)).eql?(:inflection) && stack_type(stack).eql?(:inflection)
          children(stack).each do |c|
            build_cases(c)
          end
        when stack_type(stack).eql?(:inflection)
          children(stack).each do |c|
            cases[name(stack)] = build_cases(c, {})
          end
        else
          children(stack).each do |c|
            build_cases(c, {})
          end
        end
        cases
      end
    end
  end
end
