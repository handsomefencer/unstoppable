# frozen_string_literal: true

module Roro
  module Configurators
    class Omakase < Roro::Configurators::Configurator
      def library(location = nil)
        location ||= "#{Roro::CLI.story_root}/entrees"
        hash = {}
        Dir.glob("#{location}**/*").each do |child_folder|
          story = child_folder.split('/').last.split('.yml').first
          hash[story] = library(child_folder)
        end
        sanitize(hash)
      end

      def validate_layer(story)
        scenes = get_layer(story)[:stories]
        case scenes
        when String
          File.exist?("#{story}#{scenes}.yml")
        when Array
          scenes.each { |scene| validate_story("#{story}/#{scene}") }
        end
      end

      def checkout_story(filedir)
        Dir.glob("#{filedir}/*.yml").first
      end

      def choose_your_adventure(filedir)
        title = filedir.split('').last
        choices = Dir.entries(filedir) - %w(. ..)

      end

      def choices(filedir)
        title = filedir.split('').last
        choices = Dir.entries(filedir) - %w(. ..)
      end

      def question(filedir)
        collection_name = filedir.split('/').last
        "Please choose from these #{collection_name}"
      end

      def ask_question(filedir)
        prompt = question(filedir)
        # default = question[:default]
        choices = choices(filedir)
        ask(prompt, limited_to: choices)
      end
    end
  end
end
