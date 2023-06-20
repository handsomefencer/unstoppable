# frozen_string_literal: true

require 'byebug'
module Roro
  module Configurators
    class AdventurePicker < Thor
      include Utilities

      attr_reader :inflection

      no_commands do
        def choose_adventure(stack)
          say(inflection_prompt(stack))
          ask(which_adventure?(stack), limited_to: inflection_options(stack).keys)
        end

        def inflection_prompt(stack)
          ["\n",
           'Please choose from these ',
           "#{stack_parent(stack)} ",
           "#{stack_name(stack).gsub('_', ' ')}",
           ":\n\n"].join
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

        def which_adventure?(stack)
          array = []
          inflection_options(stack).map do |key, value|
            array << [
              "#{set_color("(#{key})", :bold)} ",
              "#{set_color(value, :blue, :bold)}\n\s\s\s\s",
              get_story_preface("#{stack}/#{value}")
            ].join
          end
          array << "\n"
          array.join("\n\n")
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
