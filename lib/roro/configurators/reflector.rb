# frozen_string_literal: true

module Roro
  module Configurators
    class Reflector

      include Utilities

      attr_reader :cases, :itineraries, :matrix, :stack

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        build_cases
      end

      def build_cases(path = stack)
        cases = {
          inflections: [],
          stacks: {},
          stories: []
        }
        children(path).each_with_index do |c, index|
          case
          when [:inflection, :inflection_stub].include?(stack_type(c))
            cases[:inflections] << { stack_name(c).to_sym => build_cases(c) }
          when [:stack].include?(stack_type c)
            cases[:stacks][index + 1] = build_cases c
          when [:story].include?(stack_type c)
            cases[:stories] << index + 1
          end
        end
        @cases = cases
      end

      def build_cases_matrix(hash = cases, array = [])
        @matrix ||= []
        hash[:inflections]&.each do |inflection|
          beforesize = @matrix.dup
          inflection.each do |k, v|
            if inflection.eql?(hash[:inflections].first)
              build_cases_matrix(v, array)
              kreateds = @matrix - beforesize
              if hash[:inflections].size > 1
                kreateds.each do |kreated|
                  @matrix.delete(kreated)
                  build_cases_matrix(hash[:inflections].last.values.first, kreated)
                end
              end
            end
          end
        end
        hash[:stories]&.each do |k,_v|
          @matrix << array + [k]
        end
        hash[:stacks]&.each  { |k, v| build_cases_matrix(v, array.dup + [k]) }
        @matrix
      end
    end
  end
end
