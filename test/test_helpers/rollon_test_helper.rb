# frozen_string_literal: true
require 'deep_merge/rails_compat'

module Roro::TestHelpers
  class RollonTestHelper
    include Roro::TestHelpers::FilesTestHelper
    include Roro::TestHelpers::ConfiguratorTestHelper

    attr_reader :answers, :base_dir, :choices, :dir, :dummies,
      :filematchers, :roro_test_root, :stack_test_root, :story_path,
      :manifests, :manifest, :rollon_dummies, :rollon_loud,
      :reflector, :story_root

    def initialize(directory, options={})
      debuggerer = options&.dig(:debuggerer) || false
      @rollon_dummies = options&.dig(:rollon_dummies) || debuggerer
      @rollon_loud = options&.dig(:rollon_loud) || debuggerer
      @dir = directory
      @reflector = Roro::Configurator::StackReflector.new
      @story_root = directory.split('/stacks').first
      @story_path = directory.split("#{@story_root}/").last
      @choices = @story_path.split('/')
      @answers = infer_answers_from_testfile_location
      @manifests = gather_manifests
      @manifest = merge_manifests
      @dummies = collect_dummies
    end

    def infer_answers_from_testfile_location
      reflector.adventures
        .select { |_k, v| v[:choices].map(&:downcase).eql?(choices[1..-1]) }
        .values.first[:picks]
    end

    def gather_manifests
      [].tap do |a|
        path = story_root.dup
        choices.each do |c|
          a.concat(Dir.glob("#{path.concat("/#{c}")}/_manifest*.yml") )
        end
      end
    end

    def merge_manifests
      {}.tap do |hash|
        gather_manifests.each do |file|
          hash2 = read_yaml(file)
          hash.deeper_merge!(hash2, {:merge_hash_arrays => true})
       end
      end
    end

    def manifest_for_story(*choices)
      {}.tap do |h|
        gather_manifests.each do |file|
          choices.each do |choice|
            yaml = read_yaml(file)[choice.to_sym]
            yaml&.keys&.each do |k|
              i = (k[-1] == '!') ? :"#{k[0..-2]}" : :"#{k}!"
              h[k] = h[i] if h.keys.include?(i)
              h.delete(i) if h.keys.include?(i)
            end
            options = { merge_hash_arrays: true, keep_array_duplicates: true }
            h.deeper_merge!(yaml, options)
          end
        end
      end
    end

    def manifest_for(*choices)
      foo = {}
      choices.each do |choice|
        next unless manifest.keys.include? choice.to_sym
        if manifest.is_a?(Hash)
          bar = manifest.dig(choice.to_sym)
          bar.keys.each do |key|
            foo.reject! do |fk, _value|
              (fk.to_s.match?(key.to_s) || key.to_s.match?(fk.to_s))
            end
          end
          foo.merge!(bar)
        end
      end
      foo
    end

    def collect_dummies
      [].tap do |a|
        choices.each do |choice|
          files = manifest[choice.to_sym]&.keys&.map(&:to_s)&.reject { |f|
            f.chars.first.eql?('-')
          }
          a.concat(files) if files
        end
      end
    end

    def rollon
      stubs_adventure(dir)
      stub_overrides
      if @rollon_dummies.eql?(true)
        cli = Roro::CLI.new
        @rollon_loud ? cli.rollon : quiet { cli.rollon }
        capture_stage_dummy(dir) if @rollon_dummies.eql?(true)
      else
        if Dir.glob("#{dir}/dummy/**/*").empty? && !dummies.empty?
          raise 'Need to run your debuggerer, mate.'
        else
          copy_stage_dummy(dir)
          stub_run_actions
        end
      end
    end

    private

    def dummy_dir
      "#{dir}/dummy"
    end

    def capture_stage_dummy(dir)
      FileUtils.remove_dir(dummy_dir) if File.exist?(dummy_dir)
      dummies.each { |dummy| copy_with_path(dummy, "#{dummy_dir}/#{dummy}") }
    end

    def copy_stage_dummy(path)
      FileUtils.cp_r("#{dummy_dir}/.", Dir.pwd) if File.exist?(dummy_dir)
    end

    def stubs_adventure(path = nil, _adventure = nil)
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns(*answers)
    end

    def stub_overrides(answer = '')
      overrides = @overrides || []
      Roro::Configurators::QuestionAsker
        .any_instance
        .stubs(:confirm_default)
        .returns(*overrides).then.returns(answer)
    end

    def stub_run_actions
      Roro::Configurators::AdventureWriter
        .any_instance
        .stubs(:run)
    end

    def stubs_answer(answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .returns(answer)
    end

    def stubs_dependencies_met?(value = false)
      Roro::Configurators::Configurator
        .any_instance
        .stubs(:dependency_met?)
        .returns(value)
    end
  end
end
