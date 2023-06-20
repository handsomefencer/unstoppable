# frozen_string_literal: true

require 'byebug'
module Roro
  module Configurators
    class AdventurePicker < Thor
      include Utilities

      attr_reader :inflection

      no_commands do
        def choose_adventure(stack)
          inflection = build_inflection(stack)
          say(inflection_prompt(stack))
          # say(inflection.dig(:choose_from).join)
          # say(choose_from(stack))
          ask("Choices: #{set_color(options.keys.map { |k| k.to_i }, :blue)}", "#{humanize(stack)}\n\n")
        end

        def build_inflection(stack)
          {
            prompt: inflection_prompt(stack),
            choose_from: choose_from(stack)
          }
        end

        def inflection_prompt(stack)
          ['Please choose from these',
           stack_parent(stack),
           stack_name(stack).gsub('_', ' ') + ':',
           "\n\n"].join(' ')
        end

        def choose_from(stack)
          # options = inflection_options(stack)
          [
            "#{humanize(stack)}\n\n",
            # 'choices:'
            # ,
            "Choices: #{set_color(options.keys.map { |k| k.to_i }, :blue)}"
          ]
        end

        def humanize(stack)
          [].tap do |array|
            inflection_options(stack).map do |key, value|
              choice = set_color("(#{key})", :bold)
              name = set_color(value, :blue, :bold)
              preface = get_story_preface("#{stack}/#{value}")
              array << "#{choice} #{name}\n\s\s\s\s#{preface}"
            end
          end.join("\n\n")
        end

        def inflection_options(stack)
          {}.tap do |h|
            children(stack)
              .map { |f| stack_name(f) }
              .sort
              .each_with_index do |c, i|
                h[(i + 1).to_s] = stack_name(c)
              end
          end
        end

        def get_story_preface(story)
          storyfile = "#{story}/#{stack_name(story)}.yml"
          return unless stack_is_storyfile?(storyfile)

          read_yaml("#{story}/#{stack_name(story)}.yml")[:preface]
        end
      end
    end
  end
end
