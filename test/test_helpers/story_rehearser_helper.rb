# frozen_string_literal: true

module Roro::TestHelpers::ConfiguratorHelper
  class StoryRehearser
    attr_reader :answers, :base_dir, :choices, :dir, :dummyfiles,
      :filematchers, :roro_test_root, :stack_test_root, :story_path,
      :manifests, :manifest,
      :reflector, :story_root

    def initialize(directory, options={})
      @dir = directory
      @reflector = Roro::Configurator::StackReflector.new
      @story_root = directory.split('/stacks').first
      @story_path = directory.split("#{@story_root}/").last
      @choices = @story_path.split('/')
      @answers = infer_answers_from_testfile_location
      @manifests = gather_manifests
      @manifest = merge_manifests
      @dummyfiles = collect_dummyfiles
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

    def collect_dummyfiles
      [].tap do |a|
        choices.each do |choice|
          files = manifest[choice.to_sym]&.keys&.map(&:to_s)
          a.concat(files) if files
        end
      end
    end

    def rollon
      debuggerer if ENV['DEBUGGERER'].eql?('true')
      stubs_adventure(dir)
      if @rollon_dummies.eql?(true)
        cli = Roro::CLI.new
        @rollon_loud ? cli.rollon : quiet { cli.rollon }
        capture_stage_dummy(dir) if @rollon_dummies.eql?(true)
      else
        if glob_dir.empty?
          raise  'Need to run ya debuggerer, mate.'
        else
          copy_stage_dummy(dir)
          stub_run_actions
        end
      end
    end

    def copy_stage_dummy(path)
      debugger
      dummy_dir = "#{path}/dummy/."
      FileUtils.cp_r(dummy_dir, Dir.pwd) if File.exist?(dummy_dir)
    end

    def stubs_adventure(path = nil, _adventure = nil)
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns(*answers)
    end

    def capture_stage_dummy(dir)
      dummy_dir = "#{dir}/dummy"
      FileUtils.remove_dir(dummy_dir) if File.exist?(dummy_dir)
      FileUtils.mkdir_p(dummy_dir)
      @dummyfiles.each do |df|
        next unless File.directory?(df)

        @dummyfiles += glob_dir(df).map do |mig|
          mig = mig.split("#{Dir.pwd}/").last
        end
        @dummyfiles.delete(df)
      end
      @dummyfiles.each do |dummy|
        dummyfile = dummy.split(dummy_dir).last
        artifact = "#{Dir.pwd}/#{dummyfile}"
        next unless File.file?("#{Dir.pwd}/#{dummyfile}") && File.file?(dummyfile)

        array = dummyfile.split('/')
        array.pop
        target = array.join('/')
        FileUtils.mkdir_p("#{dummy_dir}/#{target}")
        FileUtils.cp_r(artifact, "#{dummy_dir}/#{dummy}")
      end
    end
  end
end
