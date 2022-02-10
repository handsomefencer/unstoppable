# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureWriter < Thor
      include Thor::Actions
      include Utilities

      attr_reader :itinerary, :stack, :manifest

      no_commands do

        def write(buildenv, storyfile)
          @buildenv = buildenv
          @storyfile = storyfile
          @env = buildenv[:env]
          @env[:force] = true
          @env[:exit_on_failure] = true
          actions = read_yaml(storyfile)[:actions]
          unless actions.nil?
            actions.each do |a|
              self.source_paths.shift
              self.source_paths << "#{stack_parent_path(storyfile)}/templates"
              begin
                eval a
              rescue
                raise Error, msg: "#{a} #{storyfile}"
              end
            end
          end
        end

        def copy_manifest
          paths = manifest_paths
          paths.each do |path|
            self.source_paths.shift
            self.source_paths << path
            begin
              directory '', '.', @env
            rescue
              Roro::Error
            end
          end
        end

        def polish
          if File.exist?('polisher')
            FileUtils.cp_r('polisher/.', '.')
            FileUtils.rm_rf('polisher')
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

        def section(name)
          array = []
          section_partials(name).each do |p|
            array << read_partial(p)
          end
          array.empty? ? (raise Roro::Error) : array.join("\n")
        end

        def section_partials(name)
          array = partials.select do  |p|
            p.match?(/#{name}/)
          end
          matchers = array.map { |p| p.split("/partials/#{name}/").last }.uniq
          innermosts = []
          matchers.each do |m|
            duplicates = array.select do |p|
              p.match? m
            end
            innermosts<< duplicates.last
          end
          innermosts
        end

        def partial(name)
          read_partial(partials.select { |p| p.match?(/_#{name}.*.erb/) }.last)
        end

        def read_partial(partial)
          begin
            ERB.new(File.read(partial)).result(binding) if partial
          rescue
            msg = "Missing variable in #{partial}"
            raise Roro::Error, msg
          end
        end

        def partials
          array = []
          itinerary = @buildenv[:itinerary]
          itinerary.each do |file|
            array += partials_for(file)
          end
          array.uniq
        end

        def partials_for(ancestor = nil, crumbs = nil, paths = [] )
          if crumbs.nil?
            origin = Roro::CLI.stacks
            crumbs = ancestor.split("#{origin}/").last.split('/')
            ancestor = origin
          end
          path = "#{ancestor}/templates/partials"
          paths += Dir.glob("#{path}/**/_*.erb") if File.exist?(path)
          child = "#{ancestor}/#{crumbs.shift}"
          crumbs.empty? ? paths : partials_for(child, crumbs, paths)
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