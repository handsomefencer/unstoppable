# frozen_string_literal: true

module Roro
  module Configurators
    class QuestionBuilder

      attr_reader :question

      def initialize(args)
        case
        when args[:inflection]
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
        collection = name(@inflection).gsub('_', ' ') + ":\n"
        [prompt, catalog_parent(@inflection), collection].join(' ')
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

      def story_from(key)
        inflection_options[key]
      end
    end
  end
end
