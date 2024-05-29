# frozen_string_literal: true

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
      {}.tap { |h| gather_manifests.each { |m| h.merge!(read_yaml(m)) }}
    end

    def collect_dummies
      [].tap do |a|
        choices.each do |choice|
          files = manifest[choice.to_sym]&.keys&.map(&:to_s)
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
