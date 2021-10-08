# frozen_string_literal: true

module Roro
  module Configurators
    class AskInflection < Thor
      include Utilities

      attr_reader :inflection

      no_commands do
        def choose_adventure(stack)
          build_inflection(stack)
          choice = ask(@inflection)
          story_name = story_from(choice.to_s)
          "#{stack}/#{story_name}"
        end

        def build_inflection(stack)
          @stack = stack
          prompt = inflection_prompt
          options = inflection_options
          prompt_options = humanize(options)
          @inflection = ["#{prompt} #{prompt_options}", limited_to: options.keys]
        end

        def inflection_prompt
          prompt = 'Please choose from these'
          collection = name(@stack).gsub('_', ' ') + ":\n"
          [prompt, stack_parent(@stack), collection].join(' ')
        end

        def inflection_options
          Hash.new.tap do |h|
            children(@stack)
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
            preface = get_story_preface("#{@stack}/#{value}")
            array << "\n(#{key}) #{value}:\n #{preface}"
          end
          array.join
        end

        def get_story_preface(story)
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
end
