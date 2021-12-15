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

      def build_cases(path = stack, choices = nil )
        case
        when stack_type(path).eql?(:inflection)
          choices ||= []
          cases = { name(path).to_sym => []}
          children(path).each do |c|
            choices << build_cases(c)
          end
          cases[name(path).to_sym] = choices
        when [:stack].include?(stack_type(path))
          cases = { name(path).to_sym => {} }
          children(path).each do |c|
            nc = name(c).to_sym
            if build_cases(c)
              cases[name(path).to_sym][nc] = build_cases(c)[nc]
            end
          end
        when stack_type(path).eql?(:story)
          cases = { name(path).to_sym => {} }
        end
        @cases = cases
      end

      def document_cases
        File.open("#{Dir.pwd}/mise/logs/cases.yml", "w") do |f|
          f.write(build_cases.to_yaml)
        end

        File.open("#{Dir.pwd}/mise/logs/matrix_cases.yml", "w") do |f|
          f.write(build_matrix.to_yaml)
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

      def build_matrix( hash = cases, array = [], batch = [])
        hash.each do |k, v|
          @matrix ||= []
          if v.is_a?(Hash)
            @matrix.delete(array)
            @matrix << ( array << k )
            build_matrix(v, array)
            batch.each do |b|
              # b.each do |k1, v1|
              #   v1.each do |item|
                  build_matrix(b, array)
              #   end
              # end
            end
            foo = 'bar'
          else
            hash.shift
            v.each_with_index do |item, index|
              build_matrix(item, array.dup, hash.empty? ? [] : [hash] )
            end
          end
        end
        @matrix.sort
      end

      def matrix_cases(array = [], d = 0, hash = cases)
        hash.each do |k, v|
          array = (array.take(d) << hash.keys.index(k) + 1)
          v.empty? ? @matrix << array : matrix_cases(array, d+1, v)
        end
        @matrix
      end
    end
  end
end
