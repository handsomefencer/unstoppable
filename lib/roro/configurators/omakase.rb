# frozen_string_literal: true

module Roro
  module Configurators
    class Omakase < Roro::Configurators::Configurator
      def junbi(location = nil)
        location ||= "#{Roro::CLI.story_root}/entrees"
        hash = {}
        Dir.glob("#{location}**/*").each do |child_folder|
          story = child_folder.split('/').last.split('.yml').first
          hash[story] = junbi(child_folder)
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

      def choose_your_adventure

      end
    end
  end
end
