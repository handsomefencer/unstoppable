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
        @question = ["#{prompt} #{prompt_options}", limited_to: options.keys]
      end

      def inflection_prompt
        prompt = 'Please choose from these'
        tree = @inflection.split('/')
        parent = tree[-2]
        collection = name(@inflection) + ":\n"
        [prompt, parent, collection].join(' ')
      end

      def inflection_options
        Hash.new.tap do |h|
          get_children(@inflection)
            .map { |f| name(f) }
            .sort
            .each_with_index do |c, i|
            h[(i + 1).to_s] = name(c)
          end
        end
      end

      def humanize(hash)
        array = []
        hash.map do |key, value|
          preface = get_story_preface("#{@inflection}/#{value}")
          array << "\n(#{key}) #{value}:\n #{preface}"
        end
        array.join
      end

      def get_story_preface(story)
        read_yaml("#{story}/#{name(story)}.yml")[:preface]
      end

      def answer_from(key)
        inflection_options[key]
      end
    end
  end
end
