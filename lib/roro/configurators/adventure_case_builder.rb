# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.catalog_root
        @cases =  {}
      end

      def build_cases(stack = nil, cases = {})
        stack ||= @catalog
        st  = stack_type(stack)
        sp  = stack_parent(stack)
        spt = stack_type(stack_parent_path(stack))
        case

        when stack_type(stack_parent_path(stack)).eql?(:inflection) && stack_type(stack).eql?(:inflection)
        when stack_type(stack_parent_path(stack)).eql?(:inflection) && stack_type(stack).eql?(:story)
          cases[name(stack).to_sym] = {}
          cases = cases[name(stack).to_sym]
        when stack_type(stack_parent_path(stack)).eql?(:inflection) && stack_type(stack).eql?(:stack)
          (cases[name(stack).to_sym] = {})
          cases = cases[name(stack).to_sym]
        when stack_type(stack_parent_path(stack)).eql?(:inflection)
        end
        children(stack).each do |c|
          build_cases(c, cases)
        end
        cases
      end
    end
  end
end
