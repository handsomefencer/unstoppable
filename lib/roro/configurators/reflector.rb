# frozen_string_literal: true

module Roro
  module Configurators
    class Reflector

      include Utilities

      attr_reader :cases, :itineraries,  :stack

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
      end

      def reflection(stack = nil)
        stack ||= @stack
        reflection = {
          inflections: [],
          stacks: {},
          stories: [],
          picks: []
        }
        children(stack ).each_with_index do |c, index|
          case
          when [:inflection, :inflection_stub].include?(stack_type(c))
            reflection[:inflections] << { stack_name(c).to_sym => reflection(c) }
          when [:stack].include?(stack_type c)
            reflection[:stacks][index + 1] = reflection c
          when [:story].include?(stack_type c)
            reflection[:picks] << index + 1
            story = c.split("#{Roro::CLI.stacks}/").last
            reflection[:stories] << story
          end
        end
        reflection
      end

      def cases(hash = reflection, array = [], matrix = [])
        hash[:inflections]&.each do |inflection|
          artifact = matrix.dup
          inflection.each do |k, v|
            if inflection.eql?(hash[:inflections].first)
              cases(v, array, matrix)
              kreateds = matrix - artifact
              if hash[:inflections].size > 1
                kreateds.each do |kreated|
                  matrix.delete(kreated)
                  cases(hash[:inflections].last.values.first, kreated, matrix)
                end
              end
            end
          end
        end
        hash[:picks]&.each do |k,_v|
          matrix << array + [k]
        end
        hash[:stacks]&.each  { |k, v| cases(v, (array.dup + [k]), matrix) }
        matrix
      end

      def itineraries(hash = reflection, array = [], matrix = [])
        hash[:inflections]&.each do |inflection|
          artifact = matrix.dup
          inflection.each do |k, v|
            if inflection.eql?(hash[:inflections].first)
              itineraries(v, array, matrix)
              kreateds = matrix - artifact
              if hash[:inflections].size > 1
                kreateds.each do |kreated|
                  matrix.delete(kreated)
                  itineraries(hash[:inflections].last.values.first, kreated, matrix)
                end
              end
            end
          end
        end
        hash[:stories]&.each do |k,_v|
          matrix << array + [k]
        end
        hash[:stacks]&.each  do |k, v|
          itineraries(v, array.dup, matrix)
        end
        matrix
      end
    end
  end
end
