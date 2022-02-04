# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureWriter < Thor
      include Thor::Actions
      include Utilities

      attr_reader :itinerary, :stack, :manifest

      no_commands do

        def write(buildenv, storyfile)
          @storyfile = storyfile
          @env = buildenv[:env]
          @env[:force] = true
          @env[:exit_on_failure] = true
          actions = read_yaml(storyfile)[:actions]
          unless actions.nil?
            self.source_paths << "#{stack_parent_path(storyfile)}/templates"
            actions.each do |a|
              begin
                eval a
              rescue
                raise Error, msg: "#{a} #{storyfile}"
              end
            end
            self.source_paths.shift
          end
        end

        def copy_manifest
          paths = manifest_paths
          paths.each do |path|
            self.source_paths.shift
            self.source_paths << path
            Roro::Configurators::AdventureWriter.source_root(path)
            begin
              directory '.', '.', @env[:env]
            rescue
              Roro::Error
            end

            self.source_paths.shift

          end
        end

        def copy_stage_dummy(stage)
          location = Dir.pwd
          stage_dummy = "#{stack_parent_path(stage)}/test/stage_one/stage_dummy"
          generated = Dir.glob("#{location}/**/*")
          dummies = Dir.glob("#{stage_dummy}/**/*")
          dummies.each do |dummy|
            generated.select do |g|
              if dummy.split(stage_dummy).last.match?(g.split(Dir.pwd).last)
                FileUtils.cp(g, "#{stage_dummy}/#{stack_name(g)}")
              end
            end
          end
        end

        def epilogue(log)
          array = []
          log[:itinerary].each do |i|
            parent_path = stack_parent_path(i)
            if stack_parent(i).eql?('versions')
              keyword = stack_parent(parent_path)
            else
              keyword = stack_name(i)
            end
            array << keyword
          end
          "https://www.handsomefencer.com/tutorials/#{array.join('-')}"
        end

        def write_log(log)
          create_file 'mise/log.yml', log.to_yaml
          say 'Arigato.'
          say epilogue(log)
        end

        def partial(name)
          partial = partials.select { |p| p.match? "#{name}.erb" }.last
          begin
            ERB.new(File.read(partial)).result(binding) if partial
          rescue
            msg = "Missing variable in #{partial}"
            raise Roro::Error, msg
          end
        end

        def partials( stack = nil, paths = [] )
          stack  ||= Roro::CLI.stacks
          crumbs ||= @storyfile.split("#{stack}/").last.split('/')
          path = "#{stack}/templates/partials"
          paths += Dir.glob("#{path}/**/*.erb") if File.exist?(path)
          child = "#{stack}/#{crumbs.shift}"
          crumbs.empty? ? paths : partials(child, paths)
        end

        def manifest_paths( stack = nil, array = nil, paths = [] )
          stack ||= Roro::CLI.stacks
          array ||= @storyfile.split("#{stack}/").last.split('/')
          path = "#{stack}/templates/manifest"
          if File.exist?(path)
            paths << path
          end
          child = "#{stack}/#{array.shift}"
          array.empty? ? paths : manifest_paths(child, array, paths)
        end

        def interpolated_stack_path
          "#{@env[:stack]}/#{@env[:story]}"
        end

        def interpolated_story_name
          "#{@env[:story]}"
        end

        def interpolated_app_name
          @env[:base][:app_name][:value]
        end
      end
    end
  end
end
