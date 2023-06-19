# frozen_string_literal: true

require 'deep_merge'
require 'active_support'
require 'active_support/inflector'

module Roro
  module Configurators
    class StackReflector
      include Utilities

      attr_reader :adventures, :cases, :reflection, :stack

      def initialize(stack = Roro::CLI.stacks)
        @stack = stack
        @reflection = reflect(stack)
        @adventures = @reflection[:adventures]
        @cases = @reflection[:cases]
        @reflection[:structure] = structure
        @reflection[:itineraries] = itineraries
      end

      def reflect(s, sibs = [], adventure = nil, a = {})
        adventure ||= {
          chapters: [],
          itinerary: [],
          picks: [],
          tags: []
        }
        adventure[:chapters] += stack_stories(s)
        case stack_type(s)
        when :inflection_stub
          children(s).each { |c| reflect(c, sibs, adventure, a) }
        when :inflection
          children(s).each_with_index do |c, i|
            reflect(c, sibs.dup, fork_adventure(adventure, i, s, c), a)
          end
        when :stack
          inflections = children(s).select do |c|
            %i[inflection inflection_stub].include?(stack_type(c))
          end

          reflect(inflections.shift, (sibs + inflections), adventure, a)
        when :story
          if sibs.empty?
            a[adventure[:picks].join(' ')] = add_metadata(adventure)
          else
            reflect(sibs.shift, sibs, adventure, a)
          end
        end
        {
          adventures: a,
          cases: a.keys,
          stack: @stack
        }
      end

      def itineraries
        [].tap { |a| adventures.values.each { |v| a << v[:itinerary] } }
      end

      def adventure_for(*picks)
        picks = picks.join(' ') if picks.is_a? Array
        @reflection.dig(:adventures, picks)
      end

      def structure
        {
          human: adventure_structure_human,
          choices: adventure_structure_choices
        }
      end

      private

      def deep_copy(o)
        Marshal.load(Marshal.dump(o))
      end

      def add_metadata(adventure)
        adventure[:chapters].reject! do |c|
          # byebug
          stack_name(c).chars.first.match?('_')
        end
        adventure[:tags] = tags_from(adventure[:chapters])
        adventure[:versions] = versions_from(adventure[:chapters])
        adventure[:title] = title_from(adventure)
        adventure
      end

      def tags_from(chapters)
        chapters
          .map { |c| c.split('/').last.split('.').first }
          .reject { |c| c.match?('_') }.uniq
      end

      def title_from(adventure)
        tags = adventure.dig(:tags)
        itinerary = adventure.dig(:itinerary)
        versions = adventure.dig(:versions)
        array = itinerary.reject do |i|
          i.match?('version')
          versions.keys.any? { |key| i.match?(key) }
        end
        versions.each do |tool, version|
          array << "#{tool} version: #{version}"
        end
        array.join(', ')
      end

      def versions_from(chapters)
        {}.tap do |versions|
          chapters.each do |chapter|
            next if stack_name(chapter).split('.').first.to_i.eql? 0

            tool = stack_parent(stack_parent_path(stack_parent_path(chapter)))
            versions[tool] = "#{stack_parent(chapter).gsub('_', '.')}"
          end
        end
      end

      def inflection_choice(stack, child)
        inflection_parent = stack_parent(stack)
        inflection = stack_name(stack).singularize
        foo = if inflection.eql? 'version'
                "#{inflection_parent} #{inflection}"
              else
                inflection

              end
        "#{foo}: #{stack_name(child)}"
      end

      def fork_adventure(adventure, index, stack, child)
        deep_copy(adventure).tap do |hash|
          hash[:picks] << index += 1
          hash[:itinerary] << inflection_choice(stack, child)
        end
      end

      def adventure_structure_human
        {}.tap do |h|
          itineraries.each do |array|
            hash = {}
            array.reverse.each { |i| hash = { i.split(': ').last => hash } }
            h.deep_merge!(hash)
          end
        end
      end

      def adventure_structure_choices
        {}.tap do |foo|
          cases.each do |picks|
            hash = {}
            picks.split(' ').reverse.each do |pick|
              hash = { pick.to_i => hash }
            end
            foo.deep_merge!(hash)
          end
        end
      end
    end
  end
end
