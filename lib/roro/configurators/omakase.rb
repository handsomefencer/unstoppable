# frozen_string_literal: true

module Roro
  module Configurators
    class Omakase < Roro::Configurators::Configurator

      def junbi(folder = nil)
        hash = {}
        location ||= "#{Roro::CLI.story_root}/#{story}"
        folder = "#{Roro::CLI.story_root}/#{story}"
        child_folders = "#{Dir.glob(location)}/**/*"
        child_folders.each do |key, value|
          hash[story] =
        end

        # story ||= { entrees: {} }
        # directory ||= "#{Roro::CLI.story_root}/entrees"
        # subdirectories = Dir.entries("#{Roro::CLI.story_root}/#{key}")
        # story.transform_values do |key, value|
        #   children =
        #
        # end
        # story
      end

        # hash ||= { entrees: {} }
        # directory = Roro::CLI.story_root + "/#{key}"
        #
        # hash.transform_values do |key, value|
        #   loc = Roro::CLI.story_root + "/#{key}"
        #   folders = Dir.glob(Dir.pwd)
        #   value = { some_key: :some_value}
        # end
      #   story
      # end

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
