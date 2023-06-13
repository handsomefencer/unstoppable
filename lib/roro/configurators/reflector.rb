# frozen_string_literal: true

require 'deep_merge'

module Roro
  module Configurators
    class Reflector
      include Utilities

      attr_reader :stack

      def initialize(stack = nil)
        @stack = stack || Roro::CLI.stacks
      end

      def log_to_mise(name, content)
        path = "#{Dir.pwd}/mise/logs/#{name}.yml"
        File.open(path, 'w') { |f| f.write(content.to_yaml) }
      end

      def reflection(stack = nil)
        stack ||= @stack
        reflection = {
          inflections: [],
          stacks: {},
          stories: [],
          picks: []
        }
        children(stack).each_with_index do |c, index|
          if %i[inflection inflection_stub].include?(stack_type(c))
            reflection[:inflections] << { stack_name(c).to_sym => reflection(c) }
          elsif [:stack].include?(stack_type(c))
            reflection[:stacks][index + 1] = reflection c
          elsif [:story].include?(stack_type(c))
            reflection[:picks] << index + 1
            story = c.split("#{Roro::CLI.stacks}/").last
            reflection[:stories] << story
          end
        end
        reflection
      end

      def cases(stack = @stack, sibs = [], kase = [], kases = [])
        case stack_type(stack)
        when :inflection_stub
          children(stack).each { |c| cases(c, sibs, kase, kases) }
        when :inflection
          children(stack).each_with_index do |c, i|
            cases(c, sibs.dup, kase.dup << i += 1, kases)
          end
        when :stack
          inflections = children(stack).select do |c|
            %i[inflection inflection_stub].include?(stack_type(c))
          end

          cases(inflections.shift, (sibs + inflections), kase, kases)
        when :story
          sibs.empty? ? kases << kase : cases(sibs.shift, sibs, kase, kases)
        end
        kases
      end

      def adventures(stack = @stack, sibs = [], kase = [], kases = [])
        case stack_type(stack)
        when :inflection_stub
          children(stack).each { |c| adventures(c, sibs, kase, kases) }
        when :inflection
          children(stack).each_with_index do |c, _i|
            adventures(c, sibs.dup, kase, kases)
          end
        when :stack
          inflections = children(stack).select do |c|
            %i[inflection inflection_stub].include?(stack_type(c))
          end
          adventures(inflections.shift, (sibs + inflections), kase + stack_stories(stack), kases)
        when :story
          if sibs.empty?
            kases << (kase + stack_stories(stack))
          else
            adventures(sibs.shift, sibs,
                       kase + stack_stories(stack), kases)
          end
        end
        kases
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

      def itineraries(stack = @stack, siblings = [], kase = [], kases = [])
        case stack_type(stack)
        when :inflection_stub
          children(stack).each { |c| itineraries(c, siblings, kase, kases) }
        when :inflection
          children(stack).each do |c|
            dup = (kase.dup << "#{stack_name(stack)}: #{stack_name(c)}")
            itineraries(c, siblings.dup, dup, kases)
          end
        when :stack
          inflections = children(stack).select do |c|
            %i[inflection inflection_stub]
              .include?(stack_type(c))
          end

          itineraries(inflections.shift, (siblings + inflections), kase, kases)
        when :story
          if siblings.empty?
            kases << kase
          else
            itineraries(siblings.shift, siblings, kase, kases)
          end
        end
        kases
      end

      def adventure_structure
        {
          human: adventure_structure_human,
          choices: adventure_structure_choices
        }
      end

      def adventure_structure_human
        {}.tap do |h|
          itineraries.each do |array|
            hash = {}
            array.reverse.each { |i| hash = { i.split(': ').last => hash } }
            h.deep_merge(hash)
          end
        end
      end

      def adventure_structure_choices
        {}.tap do |h|
          cases.each do |array|
            hash = {}
            array.reverse.each do |c|
              hash = { c => hash }
            end
            h.deep_merge(hash)
          end
        end
      end

      def metadata
        @implicit_tags = %w[git okonomi adventures databases frameworks stories versions]

        data = {}
        data[:adventures] = {}
        itineraries.each_with_index do |itinerary, index|
          data[:adventures][index] = {
            title: adventure_title(itinerary),
            slug: adventure_slug(itinerary),
            canonical_slug: adventure_canonical_slug(itinerary),
            tech_tags: tech_tags(itinerary),
            versioned_tech_tags: versioned_tech_tags(itinerary),
            unversioned_tech_tags: unversioned_tech_tags(itinerary)
          }
        end
        data
      end

      def tech_tags(kase = [], stack = @stack, tags = [], sibs = [])
        children = children(stack)
        case stack_type(stack)
        when :inflection_stub
          children(stack).each { |c| tech_tags(kase, c, tags, sibs) }
        when :inflection
          choice = children[kase.shift - 1]
          tech_tags(kase, choice, tags, sibs)
        when :stack
          inflections = children(stack).select do |c|
            %i[inflection inflection_stub]
              .include?(stack_type(c))
          end
          stack_stories(stack).each do |child|
            tech_tags(kase, child, tags, sibs) if stack_is_storyfile?(child)
          end
          tech_tags(kase, inflections.shift, tags, (sibs + inflections))
        when :storyfile
          tags << stack_name(stack).split('.').first
        when :story
          children(stack).each do |child|
            tech_tags(kase, child, tags, sibs)
          end
        end
        tech_tags(kase, sibs.shift, tags, sibs) unless sibs.empty?
        ignored = %w[_builder databases]
        tags.reject { |tag| ignored.include?(tag) }
      end

      def append_tech_to_version(tag, path)
        if stack_parent(path).eql?('versions')
          base = stack_name(stack_parent_path(stack_parent_path(path)))
          "#{base}#{tag.gsub(tag.chr, ':').gsub('_', '.')}"
        else
          tag
        end
      end

      def unversioned_tech_tags(itinerary)
        tech_tags(itinerary).reject do |t|
          t.match?(':')
        end
      end

      def versioned_tech_tags(itinerary)
        tech_tags(itinerary).select do |t|
          t.match?(':')
        end
      end

      def adventure_slug(itinerary)
        array = []
        itinerary.each do |i|
          keyword = i.split('/').last(3) - @implicit_tags
          array << keyword.join('_')
        end
        array.join('-')
      end

      def adventure_title(itinerary)
        itinerary.map do |item|
          item.split(': ').last
        end.join(' ')
      end

      def adventure_canonical_slug(itinerary)
        array = []
        itinerary.each do |i|
          inflections = %w[adventures databases frameworks stories versions]
          keyword = i.split('/').last(3) - inflections
          array << keyword.join('_')
        end
        array.join('-')
      end
    end
  end
end
