# frozen_string_literal: true

require 'os'

module Roro
  module Configurators
    class DependencySatisfier < Thor

      include Utilities

      attr_reader :dependencies, :checks, :dependencies, :manifest

      no_commands do

        def satisfy_dependencies(manifest = [])
          @manifest = manifest
          @dependencies = {}.tap do |d|
            d.merge!(gather_base_dependencies)
            d.merge!(gather_stack_dependencies)
          end
          gather_checks
          checks.each { |c| validate_check(c) }
          checks.each { |c| satisfy(c) }
        end

        def gather_base_dependencies(stack = Roro::CLI.dependency_root)
          {}.tap do |b|
            children(stack).each { |c| b.merge!(read_yaml(c)) }
          end
        end

        def gather_stack_dependencies
          {}.tap do |b|
            manifest.each { |c| b.merge!(read_yaml(c)[:dependencies] || {}) }
          end
        end

        def gather_checks
          @checks = []
          manifest.each do |f|
            read_yaml(f).dig(:depends_on)&.each do |c|
              @checks << c
            end
          end
          @checks
        end

        def validate_check(check)
          msg = "No #{check} dependency exists. Please define it before depending on it."
          dependencies[check.to_sym] || raise(Roro::Error, msg)
        end

        def satisfy(check)
          d = dependencies[check.to_sym]
          return if dependency_met?(check)
          # return if dependency_met?(d[:command])
          help = hint(d, :help)
          lucky = hint(d, :lucky)
          # say("Missing Dependency: #{set_color(check, :yellow)}")
          msg = ["\n\n#{set_color("Missing Dependency", :yellow)}: #{check}"]

          if lucky
            msg << "        #{set_color("Platform", :yellow)}: #{platform}"
            msg << "    #{set_color("Install with", :yellow)}: $ #{lucky.shift}"
            lucky.each do |c|
            msg << "                  $ #{c}"
            end
          end
          if help
            msg << "            Help: #{help}" if help
          end
          say(msg.join("\n\s\s"))
          if lucky && yes?("Do you feel lucky?")
            lucky.each { |c| run c }
          end
        end


        def hint(hash, key)
          case
          when
          OS.linux? && hash.dig(:overrides, platform_for(hash), key )
            hash.dig(:overrides, platform_for(hash), key)
          when hash.dig(:overrides, platform, key)
            hash.dig(:overrides, platform, key)
          when hash.dig(key)
            hash.dig(key)
          end
        end

        def dependency_met?(command)
          system(command.to_s) ? true : false
        end

        def platform_for(dependency)
          overrides = dependency.dig(:overrides)
          return if overrides.nil? || overrides.empty?
          return platform if overrides.keys.include?(platform)
          overrides.select do |key, value|
            return key if value.dig(:aliases)&.include?(platform.to_s)
          end
        end

        def platform
          case
          when OS.linux?
            distro
          else
            OS.host_os.to_sym
          end
        end

        def distro
          OS.parse_os_release[:ID].to_sym
        end
      end
    end
  end
end
