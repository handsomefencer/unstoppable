# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureCaseBuilder

      include Utilities

      attr_reader :cases, :itineraries, :matrix, :stack, :kases

      def initialize(stack=nil)
        @stack = stack || Roro::CLI.stacks
        build_cases
        @kases = reorder_cases
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
        cases
      end

      def reorder_cases(path = stack)
        kases = {
          inflections: [],
          stacks: {},
          stories: []
        }
        children(path).each do |c|
          case
          when stack_type(c).eql?(:inflection)
            kases[:inflections] << { name(c).to_sym => reorder_cases(c) }
          when stack_type(c).eql?(:stack)
            kases[:stacks][name(c).to_sym] = reorder_cases(c)
          when stack_type(c).eql?(:story)
            kases[:stories] << name(c)
          end
        end
        kases
        # kases.reject do |k|
        #   kases[k].empty?
        # end
      end

      def build_kases(hash = kases, array = [], remainder = [])
        @backlog = []
        @matrix_kases ||= []
        unless hash[:inflections].empty?
          hash[:inflections]&.each_with_index do |inflection, index|
            beforesize = @matrix_kases.dup
            inflection.each do |k, v|
              if inflection.eql?(hash[:inflections].first)
                build_kases(v, array.dup, remainder + hash[:inflections][1..-1])
                kreateds = @matrix_kases - beforesize
                kreateds.each do |kreated|
                  foo = @matrix_kases[kreated]

                end
                # build_kases(hash[:inflections].first.values.first, array.dup, remainder + hash[:inflections][1..-1])
              end
            end
          end
        end
        hash[:stories]&.each do |k,v|
          @matrix_kases << (array.dup + [k])
        end
        hash[:stacks]&.each do |k,v|
          build_kases(v, ( array.dup <<  k ) )
        end
        @matrix_kases
      end

      def document_cases
        # File.open("#{Dir.pwd}/mise/logs/cases.yml", "w") do |f|
        #   f.write(build_cases.to_yaml)
        # end

        File.open("#{Dir.pwd}/mise/logs/matrix_kases.yml", "w") do |f|
          f.write(reorder_cases.to_yaml)
        end

        # File.open("#{Dir.pwd}/mise/logs/matrix_cases.yml", "w") do |f|
        #   f.write(build_matrix.to_yaml)
        # end
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

      def build_matrix( hash = kases, array = [], batch = [])
        batch.reject! { |b| b.empty? }

        @matrix ||= []
        hash.each do |k,v|
          if v.is_a?(Hash)
            array << k
            if v.empty? && (batch.empty? || batch.first.empty?)
              @matrix << array
            else
              if v.empty?
                newbatch = batch.dup
                # newbatch.first.shift unless newbatch.empty?
                build_matrix(newbatch.first, array)
              else
                build_matrix(v, array, batch)
              end
            end
          else
            return unless k.eql?(hash.keys.first)
            v.each do |item|
              batch.unshift(hash)
              if item.eql?(v.first)
                args = [item, array.dup, batch.dup]
              else
                args = [item, array.dup, batch.dup]
              end
              build_matrix(*args)
            end
          end
        end
        @matrix.sort
      end

      def matrix_cases(array = [], d = 0, hash = cases)
        hash.each do |k, v|[]
          array = (array.take(d) << hash.keys.index(k) + 1)
          v.empty? ? @matrix << array : matrix_cases(array, d+1, v)
        end
        @matrix
      end
    end
  end
end
