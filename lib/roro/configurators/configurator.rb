# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator < Thor
      include Thor::Actions

      attr_reader :structure, :intentions, :env, :options, :story

      no_commands do
        def initialize(options = {})
          @options = sanitize(options)
          @structure = {
            intentions: {},
            choices: {},
            env_vars: {}
          }
          @story = @options[:story] || {}
          @intentions = @structure[:intentions]
          @env = @structure[:env_vars]
          @env[:main_app_name] = Dir.pwd.split('/').last
          @env[:ruby_version] = RUBY_VERSION
          @env[:force] = true
          @env[:verbose] = false
          @env[:roro_version] = VERSION
          @scene = Roro::CLI.catalog_root
        end

        def build_story
          layer_greenfield
          layer_rollon
          layer_story
          layer_okonomi
        end

        def layer_okonomi
          return unless @options.keys.include?(:okonomi)

          @structure[:okonomi] = true
          take_order
        end

        def layer_greenfield
          return unless @options.keys.include?(:greenfield)

          @structure[:greenfield] = true
          build_layers({ greenfield: :rails })
        end

        def layer_rollon
          build_layers(@story)
        end

        def layer_story
          file = '.roro_story'
          return unless File.exist?("#{file}.yml")

          overlay(get_layer(file))
        end

        def build_layers(story, location = nil)
          story = story.is_a?(Hash) ? story : { story => {} }
          story.each do |key, value|
            location = location ? "#{location}/#{key}" : key
            case value
            when Array
              value.each { |value| build_layers(value, location) }
            when true
            when
              build_layers(value, location)
            end
          end
          overlay(get_layer("#{Roro::CLI.story_root}/#{location}"))
        end

        def overlay(layer)
          layer.each do |key, value|
            @structure[key] ||= value
          end
          overlay_choices(layer) if layer[:choices]
          overlay_env_vars(layer) if layer[:env_vars]
          overlay_actions(layer) if layer[:actions]
        end

        def overlay_actions(layer)
          @structure[:actions].concat(layer[:actions])
        end

        def overlay_env_vars(layer)
          layer[:env_vars].each do |key, value|
            @structure[:env_vars][key] = value
          end
        end

        def overlay_choices(layer)
          @structure[:intentions] ||= {}
          layer[:choices].each do |key, value|
            @structure[:choices][key] = value
            @structure[:intentions][key] = value[:default]
          end
        end

        def overlay_intentions(layer)
          layer[:intentions].each do |key, value|
            @structure[:intentions][key] = value
          end
        end

        def sanitize(options)
          options ||= {}
          options.transform_keys!(&:to_sym)
          options.each do |key, value|
            case value
            when Array
              value.each { |vs| sanitize(vs) }
            when Hash
              sanitize(value)
            when true
              options[key] = true
            when String || Symbol
              options[key] = value.to_sym
            end
          end
        end

        def get_layer(filedir)
          filepath = "#{filedir}.yml"
          # key = filed.split('/').last
          # error_msg = "Cannot find that story #{key} at #{filepath}. Has it been written?"
          raise Roro::Error, "Can't find story" unless File.exist?(filepath)

          json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
          json || raise(Roro::Story::StoryMissing, "Is #{filepath} empty?")
        end

        def story_map(story = 'mise_en_place')
          array ||= []
          loc = Roro::CLI.story_root + "/#{story}"
          validate_story(loc)
          stories = Dir.glob("#{loc}/*.yml")
          stories.each do |ss|
            name = ss.split('/').last.split('.yml').first
            array << { name.to_sym => story_map([story, name].join('/')) }
          end
          array
        end

        def validate_story(story)
          scenes = get_layer(story)[:stories]
          case scenes
          when String
            File.exist?("#{story}#{scenes}.yml")
          when Array
            scenes.each { |scene| validate_story("#{story}/#{scene}") }
          end
        end

        def get_preface(scene)
          file = "#{scene}.yml"
          read_yaml(file)[:preface] if File.exist?(file)
        end

        def ask_question(prompt, choices)
          ask("#{prompt}\n\n", { limited_to: choices.keys })
        end

        def question(filedir)
          collection_name = filedir.split('/').last
          "Please choose from these #{collection_name}:"
        end

        def read_yaml(filedir)
          JSON.parse(YAML.load_file(filedir).to_json, symbolize_names: true)
        end

        def log_adventure
          directory 'roro'
          directory 'roro/log'
          create_file './roro/log/adventure', 'blah'
          story
        end

        def choose_your_adventure(scene)
          hash ||= {}
          choice = choose_plot(scene)
          child_scene = "#{scene}/#{choice}/plots"
          hash[choice] = if get_plot_choices(child_scene).empty?
                           {}
                         else
                           choose_your_adventure(child_scene)
                         end
          @questions = {}
          @story     = sanitize(hash)
        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_collection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: plot_choices.keys)
        end

        def write_story
          story = self.story
          scene ||= Roro::CLI.plot_root
          Roro::Configurators::Omakase.source_root("#{scene}/templates")
          @template_root = scene
          @destination_stack = [Dir.pwd]
          story.each do |key, _value|
            actions = get_plot("#{scene}/#{key}")[:actions]
            actions.each do |action|
              # src = 'roro'
              # dest = 'roro'
              # directory src, dest
              eval action
            end
          end
        end

        def layer_actions
          actions = []
          @story.each do |key, _value|
            plot = get_plot(key)
          end
          config.structure[:actions] = []
        end

        def choose_env_var(question)
          answer = ask(question[:question])
          eval(question[:action])
        end

        def get_plot_choices(scene)
          choices = Dir.glob("#{scene}/*.yml")
                       .map { |f| f.split('/').last }
                       .sort
          {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c.split('.yml').first } }
        end

        def get_plot_preface(scene)
          get_plot(scene) ? get_plot(scene)[:preface] : nil
        end

        def get_plot(scene)
          file = "#{scene}.yml"
          File.exist?(file) ? read_yaml(file) : nil
        end

        def plot_bank(filedir = nil)
          filedir ||= Roro::CLI.plot_root.to_s
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
          choices = Dir.glob("#{filedir}/*")
                       .select { |f| File.directory? f }
                       .map { |f| f.split('/').last }
          {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c } }
        end

        def log_adventure
          directory 'roro'
          directory 'roro/log'
          create_file './roro/log/adventure', 'blah'
          story
        end

        def choose_your_adventure(scene)
          hash ||= {}
          choice = choose_plot(scene)
          child_scene = "#{scene}/#{choice}/plots"
          hash[choice] = if get_plot_choices(child_scene).empty?
                           {}
                         else
                           choose_your_adventure(child_scene)
                         end
          @questions = {}
          @story     = sanitize(hash)
        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_collection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: plot_choices.keys)
        end

        def write_story
          story = self.story
          scene ||= Roro::CLI.catalog_root
          Roro::Configurators::Configurator.source_root("#{scene}/templates")
          @template_root = scene
          @destination_stack = [Dir.pwd]
          story.each do |key, _value|
            actions = get_plot("#{scene}/#{key}")[:actions]
            actions.each do |action|
              # src = 'roro'
              # dest = 'roro'
              # directory src, dest
              eval action
            end
          end
        end

        def layer_actions
          actions = []
          @story.each do |key, _value|
            plot = get_plot(key)
          end
          config.structure[:actions] = []
        end

        def choose_env_var(question)
          answer = ask(question[:question])
          eval(question[:action])
        end

        def get_plot_choices(scene)
          choices = Dir.glob("#{scene}/*.yml")
                       .map { |f| f.split('/').last }
                       .sort
          {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c.split('.yml').first } }
        end

        def get_plot_preface(scene)
          get_plot(scene) ? get_plot(scene)[:preface] : nil
        end

        def get_plot(scene)
          file = "#{scene}.yml"
          File.exist?(file) ? read_yaml(file) : nil
        end

        def plot_bank(filedir = nil)
          filedir ||= Roro::CLI.plot_root.to_s
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
          choices = Dir.glob("#{filedir}/*")
                       .select { |f| File.directory? f }
                       .map { |f| f.split('/').last }
          {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c } }
        end
      end
    end
  end
end
