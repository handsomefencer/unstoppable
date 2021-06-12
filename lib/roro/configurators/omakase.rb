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

      def read_yaml(filedir)
        JSON.parse(YAML.load_file(filedir).to_json, symbolize_names: true)
      end


      def checkout_story(filedir)
        Dir.glob("#{filedir}/*.yml").first
      end

      def get_adventures(filedir)
        choices = Dir.glob(filedir + '/*')
                     .select { |f| File.directory? f }
                     .map { |f| f.split('/').last }
        {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c } }
      end

      def question(filedir)
        collection_name = filedir.split('/').last
        "Please choose from these #{collection_name}:"
      end

      def get_preface(filedir)
        file = filedir + '.yml'
        read_yaml(file)[:preface] if File.exist?(file)
      end

      def ask_question(prompt, choices)
        ask("#{prompt}\n\n", { limited_to: choices.keys })
      end

      def choose_your_adventure(filedir=nil)
        filedir ||= "#{Dir.pwd}/lib/roro/stories/entrees"
        prompt = [(set_color "\n\s\s#{question(filedir)}", :blue)]
        adventures = get_adventures(filedir)
        adventures.each do |key, value|
          preface = get_preface("#{filedir}/#{value}/#{value}")
          blurb = preface.nil? ? '' : "-- #{preface}"
          prompt << "#{(set_color "(#{key}) #{value}", :blue)} #{blurb}"
        end
        ask_question(prompt.join("\n\n"), adventures)
      end
    end
  end
end
