# frozen_string_literal: true

module Roro
  module Configurators
    class Omakase < Roro::Configurators::Configurator

      def choose_your_adventure(scene=nil)
        scene ||= @scene
        # prompt = [(set_color "\n\s\s#{question(scene)}", :blue)]
        # adventures = get_adventures(scene)
        # adventures.each do |key, value|
        #   preface = get_preface("#{scene}/#{value}/#{value}")
        #   blurb = preface.nil? ? '' : "-- #{preface}"
        #   prompt << "#{(set_color "(#{key}) #{value}", :blue)} #{blurb}"
        # end
        # ask(prompt.join("\n\n"))
        question = pick_plot(scene)
        ask(question)
      end

      def choose_plot(scene)
        parent_plot = scene.split('/')[-2]
        plot_collection_name = scene.split('/').last
        plot_choices = get_plot_choices(scene)
        question = "Please choose from these #{(parent_plot.eql?('plots') ? 'roro' : parent_plot)} #{plot_collection_name}:"
        ask("#{question} #{plot_choices}", limited_to: plot_choices.keys )
      end

      def get_plot_choices(scene)
        choices = Dir.glob(scene + '/*')
                     .select { |f| File.directory? f }
                     .map { |f| f.split('/').last }
        {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c } }
      end

      def get_plot_preface(scene)
        get_plot(scene) ? get_plot(scene)[:preface] : nil
      end

      def get_plot(scene)
        file = "#{scene}.yml"
        File.exist?(file) ? read_yaml(file) : nil
      end


      def plot_bank(filedir = nil)
        filedir ||= "#{Roro::CLI.plot_root}"
        hash = {}
        Dir.glob("#{filedir}/*").each do |child_folder|
          story = child_folder.split('/').last.split('.yml').first
          hash[story] = plot_bank(child_folder)
        end
        @scene = filedir
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


      def checkout_plot(filedir)
        file = "#{filedir}.yml"
        File.exist?(file) ? read_yaml(file) : nil
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

      def get_preface(scene)
        file = scene + '.yml'
        read_yaml(file)[:preface] if File.exist?(file)
      end

      def ask_question(prompt, choices)
        ask("#{prompt}\n\n", { limited_to: choices.keys })
      end

      private

      def read_yaml(filedir)
        JSON.parse(YAML.load_file(filedir).to_json, symbolize_names: true)
      end
    end
  end
end
