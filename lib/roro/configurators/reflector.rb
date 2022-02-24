# frozen_string_literal: true

module Roro
  module Configurators
    class Reflector

      include Utilities

      attr_reader :cases, :itineraries,  :stack

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
      end


      def log_to_mise(name, content)
        path = "#{Dir.pwd}/mise/logs/#{name}.yml"
        File.open(path, "w") { |f| f.write(content.to_yaml) }
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
        hash[:stacks]&.each  { |k, v| cases(v, (array.dup + [k]), matrix) }
        hash[:picks]&.each do |k,_v|
          matrix << array + [k]
        end
        matrix
      end

      def stack_itineraries(stack)
        itineraries.select do |itinerary|
          parent = stack.split("#{Roro::CLI.stacks}/").last
          itinerary.any? do |i|
            i.match? parent
          end
        end
      end

      def itinerary_index(itinerary, stack)
        stack_itineraries(stack).index(itinerary)
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
        hash[:stacks]&.each  do |k, v|
          itineraries(v, array.dup, matrix)
        end
        hash[:stories]&.each do |k,_v|
          matrix << array + [k]
        end
        matrix
      end
    end
  end
end
