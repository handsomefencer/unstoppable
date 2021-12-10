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
        File.open("#{Dir.pwd}/mise/logs/matrix_cases.yml", "w") do |f|
          f.write(build_cases.to_yaml)
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

      def build_matrix( value = cases, array = [] )
        @matrix ||= []
        value.each do |k,v|
          case
          # when v.size > 1
          #   array << k
          when v.empty?
            array << k
            build_matrix(v, array.dup)

            @matrix << array
          when v.is_a?(Hash)
            array << k
            build_matrix(v, array.dup)

          when v.is_a?(Array)
            v.each do |item|
              # if value.keys.first.eql?(k)
                build_matrix(item, array.dup)
              # else
              #   @matrix.last.pop
              #   build_matrix(item, @matrix.last)
              # end
            end
          end
        end
        @matrix
        # array
      end

      # def build_matrix(array = [], d = -2, hash = cases)
      #   @matrix ||= []
      #   hash.each do |k, v|
      #     case
      #     when v.is_a?(Hash)
      #       # newarray = (array.take(d) << k)
      #       build_matrix(array, d, v)
      #     when v.is_a?(Array)
      #       v.each do |vv|
      #         getsome = build_matrix(array, d + 1, vv)
      #         foo = 'bar'
      #       end
      #     end
      #   end
      #   @matrix
      # end

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
