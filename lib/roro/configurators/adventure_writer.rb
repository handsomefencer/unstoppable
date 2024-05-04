# frozen_string_literal: true

module Roro
  module Configurators
    class AdventureWriter < Thor
      include Thor::Actions
      include Utilities

      attr_reader :itinerary, :stack, :manifest

      no_commands do
        def write(buildenv, storyfile)
          @adventure = buildenv
          @env = @adventure[:env]

          @env[:force] = true
          @env[:exit_on_failure] = true
          set_app_name
          actions = read_yaml(storyfile)[:actions]
          return if actions.nil?

          actions&.each do |a|
            source_paths.shift
            source_paths << "#{stack_parent_path(storyfile)}/templates"
            begin
              eval a
            rescue StandardError
              raise Error, msg: "#{a} #{storyfile}"
            end
          end
        end

        def success_response(_url, desired_response = '200')
          actual_response = system("curl -o /dev/null -s -w '%<http_code>s\n' http://localhost")
          raise Roro::Error unless actual_response.eql?(desired_response)
        end

        def generate_mise
          generator = Roro::CLI.new
          generator.generate_mise
          generator.generate_containers 'app', 'db'
          generator.generate_environments @env
          generator.generate_environment_files @env
          generator.generate_keys
        end

        def copy_layer(dir)
          paths = @adventure.dig(:templates_paths)
          paths.each do |path|
            source_paths.shift
            source_paths << path
            begin
              directory dir, '.', @env
            rescue StandardError
              Roro::Error
            end
          end
        end

        def section(name)
          array = []
          section_partials(name).each do |p|
            array << read_partial(p)
          end
          array.empty? ? (raise Roro::Error) : array.join("\n")
        end

        def set_app_name
          if ENV['APP_NAME']
            app_name = ENV['APP_NAME'].split('/').last
            @env[:base][:app_name][:value] = app_name
          end
        end

        def section_partials(name)
          array = partials.select do |p|
            p.match?(/#{name}/)
          end
          matchers = array.map { |p| p.split("/partials/#{name}/").last }.uniq
          innermosts = []
          matchers.each do |m|
            duplicates = array.select do |p|
              p.match? m
            end
            innermosts << duplicates.last
          end
          innermosts
        end

        def partial(name)
          read_partial(partials.select { |p| p.match?(/_#{name}.*.erb/) }.last)
        end

        def read_partial(partial)
          ERB.new(File.read(partial)).result(binding) if partial
        rescue StandardError
          msg = "Missing variable in #{partial}"
          raise Roro::Error, msg
        end

        def partials
          array = []
          itinerary = @adventure[:chapters]
          itinerary.each do |file|
            array += partials_for(file)
          end
          array.uniq
        end

        def partials_for(ancestor = nil, crumbs = nil, paths = [])
          if crumbs.nil?
            origin = Roro::CLI.stacks
            crumbs = ancestor.split("#{origin}/").last.split('/')
            ancestor = origin
          end
          path = "#{ancestor}/templates/partials"
          paths += Dir.glob("#{path}/**/_*.erb") if File.exist?(path)
          if crumbs.empty?
            paths
          else
            partials_for("#{ancestor}/#{crumbs.shift}", crumbs, paths)
          end
        end

        def epilogue(log)
          array = []
          log[:itinerary].each do |i|
            parent_path = stack_parent_path(i)
            keyword = if stack_parent(i).eql?('versions')
                        stack_parent(parent_path)
                      else
                        stack_name(i)
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
      end
    end
  end
end
