# frozen_string_literal: true

module Roro
  module Configurators
    class AdventurePicker < Thor

      include Utilities

      attr_reader :inflection

      no_commands do
        def choose_adventure(stack)
          build_inflection(stack)
          say("Rolling story on from stack: #{@stack}\n\n")
          say(@prompt)
          choice = ask(@inflection)
          story_name = story_from(choice.to_s)
          "#{stack}/#{story_name}"
        end

        def build_inflection(stack)
          @stack = stack
          prompt = inflection_prompt
          options = inflection_options
          prompt_options = humanize(options)
          @prompt = "#{prompt}\n"
          @inflection = ["#{prompt_options}\n\n", "Choices: [#{set_color(options.keys.map { |k| k.to_i }.join(' '), :blue)}]"]
        end

        def inflection_prompt
          prompt = 'Please choose from these'
          collection = stack_name(@stack).gsub('_', ' ') + ":\n"
          [prompt, stack_parent(@stack), collection].join(' ')
        end

        def inflection_options(stack = nil)
          stack ||= @stack
          Hash.new.tap do |h|
            children(stack)
              .map { |f| stack_name(f) }
              .sort
              .each_with_index do |c, i|
              h[(i + 1).to_s] = stack_name(c)
            end
          end
        end

        def humanize(hash)
          array = []
          hash.map do |key, value|
            preface = get_story_preface("#{@stack}/#{value}")
            array << "#{set_color("(#{key})", :bold)} #{set_color(value, :blue, :bold)}\n\s\s\s\s#{preface}"
          end
          array.join("\n\n")
        end

        def get_story_preface(story)
          storyfile = "#{story}/#{stack_name(story)}.yml"
          if stack_is_storyfile?(storyfile)
            read_yaml("#{story}/#{stack_name(story)}.yml")[:preface]
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
