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

      # def get_layer(filedir)
      #   filepath = "#{filedir}.yml"
      #   key = filepath.split('/').last
      #   error_msg = "Cannot find that story #{key} at #{filepath}. Has it been written?"
      #   raise Roro::Error, error_msg unless File.exist?(filepath)
      #
      #   json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
      #   json || raise(Roro::Story::StoryMissing, "Is #{filepath} empty?")
      # end

      # def story_map(story = 'stories')
      #   array ||= []
      #   loc = Roro::CLI.story_root + "/#{story}"
      #   validate_story(loc)
      #   stories = Dir.glob("#{loc}/*.yml")
      #   stories.each do |ss|
      #     name = ss.split('/').last.split('.yml').first
      #     array << { name.to_sym => story_map([story, name].join('/')) }
      #   end
      #   array
      # end

      # def validate_story(story)
      #   scenes = get_layer(story)[:stories]
      #   case scenes
      #   when String
      #     File.exist?("#{story}#{scenes}.yml")
      #   when Array
      #     scenes.each { |scene| validate_story("#{story}/#{scene}") }
      #   end
      # end
    end
  end
end
