# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      include Utilities

      attr_reader :cases, :itineraries, :matrix, :stack

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        build_cases
      end

      def build_itinerary( array = [], path = stack )
        case
        when stack_type(path).eql?(:inflection)
          children(path).each do |c|
            build_itinerary(array, c)
          end
        when stack_type(path).eql?(:stack)
          foo = 'bar'
        when stack_type(path).eql?(:story)
          foo = 'baz'
        else
          foo = 'baz'
        end
      end

      def build_cases(path = stack)
        cases = {
          inflections: [],
          stacks: {},
          stories: []
        }
        children(path).each_with_index do |c, index|
          case
          when stack_type(c).eql?(:inflection)
            cases[:inflections] << { name(c).to_sym => build_cases(c) }
          when stack_type(c).eql?(:stack)
            cases[:stacks][index + 1] = build_cases(c)
          when stack_type(c).eql?(:story)
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
        hash[:stories]&.each { |k,_v| @matrix << array + [k] }
        hash[:stacks]&.each  { |k, v| build_cases_matrix(v, array.dup + [k]) }
        @matrix
      end

      def document_cases
        File.open("#{Dir.pwd}/mise/logs/cases_matrix.yml", "w") do |f|
          f.write(build_cases_matrix.to_yaml)
        end
      end

      def case_from_path(stack, array = nil)
        if @case.nil?
          @case = []
          array = stack.split("#{@stack}/").last.split('/')
          stack = @stack
        end
        folder = array.shift
        stack = "#{stack}/#{folder}"
        @case << folder if stack_is_adventure?(stack)
        case_from_path(stack, array) unless array.empty?
        @case
      end

      def case_from_stack(stack)
        hash = cases
        case_from_path(stack).map do |item|
          _index = hash.keys.index(item.to_sym)
          hash = hash[item.to_sym]
          _index += 1
        end
      end
    end
  end
end
