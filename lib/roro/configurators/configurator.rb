# frozen_string_literal: true

require_relative 'validations'
require_relative 'utilities'

module Roro
  module Configurators
    class Configurator < Thor
      include Thor::Actions
      include Validations
      include Utilities

      attr_reader :structure, :env, :options, :story

      no_commands do
        def initialize(options=nil)
          options ||= {}
          @options = sanitize(options)
          @scene = Roro::CLI.catalog_root
          catalog_structure = StructureBuilder.new(options[:structure])
          @structure = catalog_structure.structure
          @manifest = @structure
        end

        ## steps
        # choose_adventure
        #   get plot choices (inflections)
        #   ask question
        #   store answer recursively
        #  {
        #   docker_compose: 'docker_compose',
        #   k8s: 'k8s',
        #   ruby:
        #     ruby,
        #     rails:
        #       "rails",
        #       {
        #       ruby:
        # }

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

        def merge_stories(files)
          files.each { |f| @structure.merge!(read_yaml(f)) if f.match?('.yml') }
        end

        def merge_story(file)
          content = read_yaml(file)
          [:actions].each do |key|
            content[key].each do |item|
              @structure[key] = @structure[key] << item
            end
          end
          @structure = content
          # story ||= content
          # story.each do |key, value|
          #   case @story
          #
          #   end
          # end

          # content ? @story.merge!(content) : ./raise("No content in #{file}")
          # content.each do |key, value|
          #   case key
          #   @story[key]
          #   end
          #   getsome = @story[key]
          #   # @story[key] = getsome << value
          #   # @story
          # end
        end

        def child_type(child)
          case
          when child.split('/').last.match?('templates')
            :template
          when child.split('.').last.match?('yml')
            :yml
          when !get_children(scene).any? { |w| w.include? '.yml' }
            :inflection
          end
        end

        def child_is_template?(child)
          child.split('/').last.match?('templates')
        end
        def catalog_is_template?
          @catalog.split('/').last.match?('templates')
        end
        def catalog_is_empty?
          get_children(@catalog).empty?
        end

        def story_is_dotfile?
          %w[keep gitkeep].include?(@extension)
        end

        def child_is_dotfile?(child)
          child.split('.').last.match?('keep')
        end

        def story_has_unpermitted_extension?
          !(@permitted_extensions + %w[keep gitkeep]).include?(@extension)
        end

        def story_is_empty?
          content = read_yaml(@catalog)
          @content = content if content
          !content
        end

        def catalog_not_present?
          !File.exist?(@catalog)
        end

        def catalog_is_story_file?
          File.file?(@catalog)
        end

        def child_is_yaml?(child)
          child.split('.').last.match?('yml')
        end

        def child_is_empty?(child)
          get_children(child).empty?
        end

        def child_is_story_directory?(child)
          kids = get_children(child)

          kids.size.eql?(1) && kids.first.split('.').last.match?('yml')
        end

        def child_is_inflection?(child)
          !get_children(child).any? { |w| w.include? '.yml' }
        end

        def roll_child_story(location)
          case
          when child_is_yaml?(location)
            merge_story(location)
          when child_is_template?(location)
            return
          when child_is_dotfile?(location)
            return
          when child_is_inflection?(location)
            answer = choose_plot(location)
            roll_child_story("#{location}/#{answer}")
          when child_is_empty?(location)
            return
          when get_children(location).size > 0
            get_children(location).each { |child| roll_child_story(child) }
          end
          @structure
        end

        def roll_your_own(scene = nil)
          get_children(scene ||= "#{@scene}/roro").each do |child|
            roll_child_story(child)
          end
          @destination_stack = [Dir.pwd]
          current_dir = Dir.pwd
          kidz = get_children(current_dir)
          create_file('.adventure_log', @structure.to_yaml)

          @structure[:actions].each do |a|
            eval a
          end
        end

        def get_plot_preface(scene)
          get_plot(scene) ? get_plot(scene)[:preface] : nil
        end

        def choose_plot(scene)
          parent_plot = scene.split('/')[-2]
          plot_collection_name = scene.split('/').last
          plot_choices = get_plot_choices(scene)
          return if plot_choices.empty?
          question = "Please choose from these #{parent_plot} #{plot_collection_name}:"
          ask("#{question} #{plot_choices}", limited_to: plot_choices.keys.map(&:to_s))
        end

        def get_plot_choices(scene)
          choices = get_children(scene)
                      .map { |f| f.split('/').last }
                      .sort
          {}.tap { |hsh| choices.each_with_index { |c, i| hsh[i + 1] = c.split('.yml').first } }
        end
      end
    end
  end
end
