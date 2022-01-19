# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureWriter < Thor
      include Thor::Actions
      include Utilities

      attr_reader :itinerary, :stack, :manifest

      no_commands do

        def write(buildenv, storyfile)
          @env = buildenv[:env]
          @env[:force] = true
          actions = read_yaml(storyfile)[:actions]
          unless actions.nil?
            self.source_paths << "#{stack_parent_path(storyfile)}/templates"
            actions.each do |a|
              eval a
            end
            # copy_stage_dummy(storyfile)
            self.source_paths.shift
          end
        end

        def copy_stage_dummy(stage)
          location = Dir.pwd
          stage_dummy = "#{stack_parent_path(stage)}/test/stage_one/stage_dummy"
          generated = Dir.glob("#{location}/**/*")
          dummies = Dir.glob("#{stage_dummy}/**/*")
          dummies.each do |dummy|
            # dummy = dummy.split(stage_dummy).last
            generated.select do |g|
              # g = g.split(Dir.pwd).last
              if dummy.split(stage_dummy).last.match?(g.split(Dir.pwd).last)
                FileUtils.cp(g, "#{stage_dummy}/#{name(g)}")
                foo = File.read(dummies.first)
                bar = 'baz'
              end
            end
          end
        end

        def partial(filename)
          File.read("#{self.source_paths.last}/partials/_#{filename}")
        end

        def interpolated_stack_path
          "#{@env[:stack]}/#{@env[:story]}"
        end

        def interpolated_story_name
          "#{@env[:story]}"
        end

        def write_log(log)
          create_file 'mise/log.yml', log.to_yaml
        end
      end
    end
  end
end
