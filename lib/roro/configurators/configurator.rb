# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator < Thor
      include Thor::Actions

      attr_reader :structure, :env, :options, :story

      no_commands do
        def initialize(options=nil)
          options ||= {}
          @options = sanitize(options)
          @scene = Roro::CLI.catalog_root
          @structure = StructureBuilder.build(options[:structure])
          @manifest = @structure
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

          # end
        end

        def story_is_dotfile?
          %w[keep gitkeep].include?(@extension)
        end

        def story_has_unpermitted_extension?(extension)
          !(@permitted_extensions + %w[keep gitkeep]).include?(extension)
        end

        def story_is_empty?
          content = read_yaml(@catalog)
          @content = content if content
          !content
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



      end
    end
  end
end
