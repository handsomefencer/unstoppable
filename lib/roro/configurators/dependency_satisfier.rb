# frozen_string_literal: true

module Roro
  module Configurators
    class DependencySatisfier < Thor

      attr_reader :dependencies

      no_commands do

        def satisfy_dependencies(manifest = [])
          @manifest = manifest
          @dependencies = {}.tap do |d|
            d.merge!(gather_base_dependencies)
            d.merge!(gather_stack_dependencies)
          end
        end

        def gather_base_dependencies(stack = "#{Roro::CLI.dependency_root}")
          @base_dependencies = {}.tap do |b|
            children(stack).each { |c| b.merge!(read_yaml(c)) }
          end
        end

        def gather_stack_dependencies
          @stack_dependencies = {}.tap do |b|
            @manifest.each { |c| b.merge!(read_yaml(c)[:dependencies] || {}) }
          end
        end

        def choose_adventure(stack)
          build_inflection(stack)
          say("Rolling story on from stack: #{@stack}\n\n")
          say(@getsome)
          choice = ask(@inflection)
          story_name = story_from(choice.to_s)
          "#{stack}/#{story_name}"
        end

        def build_inflection(stack)
          @stack = stack
          prompt = inflection_prompt
          options = inflection_options
          prompt_options = humanize(options)
          @getsome = "#{prompt}\n"
          @inflection = ["#{prompt_options}\n\n", "Choices: [#{set_color(options.keys.map { |k| k.to_i }.join(' '), :blue)}]"]
        end

        def inflection_prompt
          prompt = 'Please choose from these'
          collection = name(@stack).gsub('_', ' ') + ":\n"
          [prompt, stack_parent(@stack), collection].join(' ')
        end

        def inflection_options(stack = nil)
          stack ||= @stack
          Hash.new.tap do |h|
            children(stack)
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
            array << "#{set_color("(#{key})", :bold)} #{set_color(value, :blue, :bold)}\n\s\s\s\s#{preface}"
          end
          array.join("\n\n")
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
