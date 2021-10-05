# frozen_string_literal: true

module Roro
  module Configurators
    class QuestionBuilder

      attr_reader :question, :storyfile, :inflection

      def initialize(args={})
        case
        when args[:inflection]
          @inflection = args[:inflection]
        when args[:storyfile]
          @storyfile = args[:storyfile]
        end
      end

      def override(environment, key, value, override_value=nil)
        @question = "#{override_prompt(environment, key, value)}"
      end

      def override_prompt(environment, key, value)
        name = value.dig(:name) || key
        prompt = "Would you like to accept the default value for #{name}?\n"
        help = value.dig(:help) ? "#{value.dig(:help)}" : nil
        default = "#{key}=#{value[:value]}"
        ["\nEnvironment: #{environment}",
         "       name: #{name}",
         "        key: #{key}",
         "   variable: #{value[:value]}",
         "    default: #{default}",
         "       help: #{help}\n"
        ].join("\n")
      end

      def build_inflection
        prompt = inflection_prompt
        options = inflection_options
        prompt_options = humanize(options)
        @question = ["#{prompt} #{prompt_options}", limited_to: options.keys]
      end

      def inflection_prompt
        prompt = 'Please choose from these'
        collection = name(@inflection).gsub('_', ' ') + ":\n"
        [prompt, stack_parent(@inflection), collection].join(' ')
      end

      def inflection_options
        Hash.new.tap do |h|
          children(@inflection)
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

      def get_story_preface(story
      )
        storyfile = "#{story}/#{name(story)}.yml"
        if stack_is_storyfile?(storyfile)
          read_yaml("#{story}/#{name(story)}.yml")[:preface]
        else
          nil
        end
      end


      def story_from(key)
        inflection_options[key]
      end
    end
  end
end
