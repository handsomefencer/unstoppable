# frozen_string_literal: true

module Roro::TestHelpers::ConfiguratorHelper
  class Rollon < Minitest::Spec
    attr_reader :answers, :choices, :dir, :dummyfiles,
      :filematchers, :roro_test_root, :stack_test_root,
      :manifests, :reflector

    def getsome(directory)
      @dir = directory
      @roro_test_root = "#{Roro::CLI.test_root}/roro"
      @stack_test_root = "#{roro_test_root}/stacks"
      set_manifest_for_rollon(dir)
      @choices = filematchers[0..-2].reverse
      @reflector = Roro::Configurator::StackReflector.new
      @answers = infer_answers_from_testfile_location(directory)
    end

    def infer_answers_from_testfile_location(path = nil)
      reflector.adventures
        .select { |_k, v| v[:choices].map(&:downcase).eql?(choices) }
        .values.first[:picks]
    end

    def set_manifest_for_rollon(dir, array = [])
      array = dir.split("#{roro_test_root}/").last.split('/')
      name = array.pop
      @filematchers ||= []
      @filematchers << name
      manifest = "#{stack_test_root}/_manifest.yml"
      files = read_yaml(manifest)[name.to_sym]&.keys&.map(&:to_s)
      @dummyfiles ||= []
      @dummyfiles += files if files
      set_manifest_for_rollon(array.join('/')) unless array.empty?
    end

    def gather_manifests(array=filematchers, path=roro_test_root, manifests=[])
      path = "#{path}/#{array.pop}"
      manifests += Dir.glob("#{path}/_manifest*.yml")
      array.empty? ? manifests : gather_manifests(array, path, manifests)
    end

    def merge_manifests(array=gather_manifests, hash={})
      hash.merge!(read_yaml(array.shift))
      array.empty? ? hash : merge_manifests(array, hash)
    end

    def rollon
      set_manifest_for_rollon(dir)
      debuggerer if ENV['DEBUGGERER'].eql?('true')
      stubs_adventure(dir)
      if @rollon_dummies.eql?(true)
        cli = Roro::CLI.new
        @rollon_loud ? cli.rollon : quiet { cli.rollon }
        capture_stage_dummy(dir) if @rollon_dummies.eql?(true)
      else
        copy_stage_dummy(dir)
        stub_run_actions
      end
    end

    def assert_correct_manifest(dir = nil, hash = nil)
      manifests = Dir.glob("#{Roro::CLI.test_root}/roro/stacks/_*.yml")
      manifests.each do |manifest|
        verify_manifest(dir, manifest.split('/').last)
      end
    end

    def verify_manifest(dir = nil, file = nil)
      hash ||= read_yaml("#{Roro::CLI.test_root}/roro/stacks/#{file}")
      @filematchers.reverse.each do |fm|
        hash.dig(fm.to_sym)&.each do |filename, matchers|
          if matchers.nil?
            assert_file filename.to_s
          else
            matchers.each do |matcher|
              msg = "#{filename} in #{dir}/dummy/#{filename} does not contain #{matcher}"
              if matcher.is_a?(Hash)
                assert_yaml(filename.to_s, matcher)
              elsif matcher.chars.first.match?('/')
                regex = matcher.chars
                regex.shift
                regex.pop
                regex.join
                begin
                  assert_file(filename.to_s, eval("#{matcher}"))
                rescue
                  debugger
                end
              else
                assert_file(filename.to_s, eval(matcher))
              end
            end
          end
        end
      end
    end
  end
end
