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

        def merge_story(story)
          children = Dir.glob("#{scene}/**/*.yml")

        end

        def get_children(scene)
          Dir.glob("#{scene}/*")
        end

        def merge_story_files(children)
          merge_stories(children)
        end

        def merge_stories(files)
          files.each { |f| @story.merge!(read_yaml(f)) if f.match?('.yml') }
        end

        def validate_story(file)
          content = read_yaml(file)
          case
          when content.eql?(false)
            content ? @story.merge!(content) : raise("No content in #{file}.")
          when !content.keys.include?('blah')
            'blah'
          end
        end

        def merge_story(file)
          content = read_yaml(file)
          content ? @story.merge!(content) : raise("No content in #{file}")
        end

        def child_is_template?(child)
          child.split('/').last.match?('templates')
        end

        def choose_stories(children)
          children.each do |child|
            next if child_is_template?(child)
            child
          end
        end

        def is_inflection?(scene)
          children = get_children(scene)
          (children.any? { |w| w.include? '.yml' }) ? false : true
        end

        def roll_child_story(location)
          child = location.split('/').last
          case
          when child.match?('.yml')
            merge_story(location)
          when child.match?('template')
            return
          when is_inflection?(location)
            roll_child_story("#{location}/#{choose_plot(location)}")
          when get_children(location).size > 0
            get_children(location).each { |child| roll_child_story(child) }
          end
        end

        def roll_your_own(scene = nil)
          get_children(scene ||= "#{@scene}/roro").each do |child|
            roll_child_story(child)
          end
        end

        def add_story?(scene)
          parent_plot = scene.split('/')[-2]
          plot_collection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: plot_choices.keys)
        end

        def has_story?(scene)
          children = Dir.glob("#{scene}/**/*")
          children.any? { |w| w.include? '.yml' } #=> false
        end

        def scene_type(scene)
          children = Dir.glob("#{scene}/**/*")
          children
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
        private
        def choose_env_var(question)
          answer = ask(question[:question])
          eval(question[:action])
        end

        def get_plot_choices(scene)
          choices = get_children(scene)
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
