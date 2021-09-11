# frozen_string_literal: true

require_relative 'validations'
require_relative 'utilities'

module Roro
  module Configurators
    class QuestionBuilder

      attr_reader :question

      def initialize(args)
        if args[:inflection]
          @inflection = args[:inflection]
          build_from_inflection
        end
      end

      def build_from_inflection
        prompt = inflection_prompt
        options = inflection_options
        prompt_options = humanize(options)
        ["#{prompt} #{prompt_options}", limited_to: options.keys]
      end

      def inflection_prompt
        prompt = 'Please choose from these'
        tree = @inflection.split('/')
        parent = tree[-2]
        collection = tree.last
        [prompt, parent, collection].join(' ')
      end

      def inflection_options
        Hash.new.tap do |h|
          get_children(@inflection)
            .map { |f| f.split('/').last }
            .sort
            .each_with_index do |c, i|
            h[(i + 1).to_s] = c.split('.').first
          end
        end
      end

      def humanize(hash)
        array = []
        hash.map do |key, value|
          preface = get_story_preface("#{@inflection}/#{value}")
          array << "(#{key}) #{value}:\n\t #{preface}"
        end
        array.join('\n')
      end

      def get_story_preface(story)
        name = story.split('/').last.split('.').first
        read_yaml("#{story}/#{name}.yml")[:preface]
      end
    end
  end
end
