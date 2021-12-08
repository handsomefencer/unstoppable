# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      include Utilities
      attr_reader :cases, :itineraries, :matrix, :matrix_human, :kases, :stack

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        build_cases
      end

      def build_matrix(path = stack, choices = nil )
        case
        when stack_type(path).eql?(:inflection)
          choices ||= []
          matrix = { name(path).to_sym => []}
          children(path).each do |c|
            choices << build_matrix(c)
          end
          matrix[name(path).to_sym] = choices
        when [:stack].include?(stack_type(path))
          matrix = { name(path).to_sym => {} }
          children(path).each do |c|
            nc = name(c).to_sym
            if build_matrix(c)
              matrix[name(path).to_sym][nc] = build_matrix(c)[nc]
            end
          end

        when stack_type(path).eql?(:story)
          matrix = { name(path).to_sym => {} }
        else
          return
        end
        matrix
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
        @cases = sort_hash_deeply(cases)
      end

      def chooseables(stack)
        children(stack).select do |c|
          [:inflection].include?(stack_type(c))
        end
      end

      # def human(array = [], hash = cases, d = 0 )
      #   hash   ||= cases
      #   @plots ||= []
      #   @foo   ||= 0
      #   hash.each do |k, v|
      #     if hash.keys.first.eql?(k)
      #       @foo += 1
      #     end
      #     array << k
      #     human(array.dup, v, d + 1)
      #     @plots << array
      #     array  = array.take(d)
      #     if hash.keys.last.eql?(k)
      #       @foo = @foo - 1
      #     end
      #   end
      #   @plots
      # end

      def human(array = [], hash = cases, d = 0 )
        hash   ||= cases
        @plots ||= []
        @foo   ||= 0
        hash.each do |k, v|
          d += 1
          # array = array.take(d)
          array << k
          if k.eql?(:fatsufodo)
            human(array.dup, v, d) #unless v.empty?
          end
          human(array.dup, v, d) #unless v.empty?
          @plots << array
        end
        @plots
        cases
      end

      def matrix_cases_human(stack = nil, array = [], d = 0)
        stack ||= @stack
        array << name(stack) if stack_is_adventure?(stack)
        chooseables = chooseables(stack)
        iterables = children(stack) - chooseables
        chooseables.each do |c|
          if c.eql?(chooseables.first)
            @level = array.size
            d = d + 1
            matrix_cases_human(c, array, @level)
          end
          if c.eql?(chooseables.last)
            @matrix << array unless array.empty?
            matrix_cases_human(c, array, d)
          else
            matrix_cases_human(c, array, d)
          end
        end
        iterables.each do |c|
          next if [:ignored, :templates].include?(stack_type(c))
          matrix_cases_human(c, array, d)
        end
        array
      end

      def document_cases
        getsome = {
          devops: [
            stories: {
              circleci: {}
            }
          ],
          fatsufodo: [
            stories: {
              django: {},
              expressjs: {},
              flask: {},
              rails: {},
              wordpress: {}
            }
          ],
          okonomi: [
            languages: [
              python: {},
              ruby: [
                databases: {
                  maria: [
                    versions: {
                      v15_1: {},
                      v16_2: {}
                    }
                  ],
                  postgres: [
                    versions: {
                      v12_2: {},
                      v13_1: {}
                    }
                  ]
                },
                stories: {
                  rails: [
                    versions: {
                      v6_1: {},
                      v7_0: {}
                    }
                  ]
                },
                versions: {
                  v2_7: {},
                  v3_0: {}
                }
              ]
            ]
          ]
        }
        File.open("#{Dir.pwd}/test/helpers/experimental_cases.yml", "w") do |f|
          f.write(build_matrix.to_yaml)
        end
        # workflow = "#{Dir.pwd}/.circleci/src/workflows/test-matrix-rollon.yml"
        # hash = read_yaml("#{workflow}")
        # hash[:jobs][0][:"test-rollon"][:matrix][:parameters][:answers] = matrix_cases
        # File.open(workflow, "w") { |f| f.write(hash.to_yaml) }
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
