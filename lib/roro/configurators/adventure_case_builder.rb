# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      attr_reader :cases, :itineraries

      def initialize(catalog=nil)
        @catalog = catalog || Roro::CLI.stacks
        @cases =  {}
      end

      def build_cases(stack = nil, cases = {})
        stack ||= @catalog
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
    end
  end
end
