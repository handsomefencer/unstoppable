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

      def reflect(stack=nil)
        stack ||= @stack
        reflection = {
          inflections: [],
          stacks: {},
          stories: [],
          picks: []
        }
        array = []
        children(stack ).each_with_index do |c, index|
          case
          when [:inflection_stub].include?(stack_type(c))
            array  << { stack_name(c).to_sym => reflect(c) }
          when [:inflection].include?(stack_type(c))
            array  << { stack_name(c).to_sym => reflect(c) }
          when [:stack].include?(stack_type c)
            reflection[:stacks][index + 1] = reflection c
          when [:story].include?(stack_type c)
            reflection[:picks] << index + 1
            # story = c.split("#{Roro::CLI.stacks}/").last
          when [:storyfile].include?(stack_type(c))
            foo = 'bar'
          else

            foo = 'bar' # reflection[:stories] << story
          end
        end
        # reflection
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

      def tech_tags(itinerary)
        tags = []
        itinerary.each do |i|
          path = "#{Roro::CLI.stacks}"
          i.split('/').each do |item|
            path = "#{path}/#{item}"
            tags += stack_stories(path)
                  .map {|s| stack_name(s).split('.yml').first }
                  .reject {|s| s.chr.eql?('_') }
                  .map { |s| append_tech_to_version(s, path)}

          end
        end
        tags.uniq
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
        versioned_tags = versioned_tech_tags(itinerary)
        redundant = versioned_tags.map {|t| t.split(':').first }
        tags = tech_tags(itinerary) - redundant

        (tags - @implicit_tags).join(' ')
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
