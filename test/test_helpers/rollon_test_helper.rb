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

    def manifest_for_story
      {}.tap do |h|
        manifests.each do |d|
          next unless read_yaml(d)
          choices.each do |c|
            override_manifest_choice(h, read_yaml(d)[c.to_sym])
            begin
            rescue
  # debugger
  # raise RuntimeError, msg: "#{dir}: #{d}: #{c}"
            end
          end
        end
      end
    end

    def override_manifest_choice(h, override)
      override&.each do |k, v|
        hash = h
        key = k
        file = k
        value = v
        if k[-1] == '!'
          previous = :"#{key[0..-2]}"
          h[k] = h.delete(previous) if h.keys.include?(previous)
        else
          previous = :"#{k}!"
          h[k] = h.delete(previous) if h.keys.include?(previous)

        end
        case v
        when Hash
          h[k] = override_hash_nodes(h[k] ||= {}, v)
        when Array
          override_array_nodes(v, h[k])
        end
      end
      options = {
        merge_hash_arrays: true
      }
      h.deeper_merge!(override, options )
    end

    def override_file_expectation(h, file)
      i = (file[-1] == '!') ? :"#{file[0..-2]}" : :"#{file}!"
      h[file] = h.delete(i) if h.keys.include?(i)
    end

    def override_array_nodes(array, h)
      array&.each do |v|
        strip_whitespace_from_evaluator(v)

        h&.delete((v[-1] == '!') ? v[0..-2] : "#{v}!")
      end
    end

    def override_hash_nodes(hash, override)
      case override
      when Array
        override_array_nodes(override, hash)
      when String
      when Hash
        return hash if override.is_a?(String)
        override&.each do |key, value|
          bar = (key[-1] == '!') ? "#{key[0..-2]}" : "#{key}!"
          bar = bar.to_sym
          if hash.keys.include?(bar)
            hash[key] = hash.delete(bar)
          else
            begin
              hash[key] = override_hash_nodes((hash[key] || {}), override[key])
            rescue
              debugger
            end
          end
        end
      end
      hash
    end

    def strip_whitespace_from_evaluator(string)
      string.gsub!(/\/\s!/, '/!')
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
      files = manifest_for_story&.keys&.map(&:to_s)
      # debugger
      files&.reject { |f|
            f[-1] == '!'
          }
    end

    # def collect_dummies
    #   [].tap do |a|
    #     choices.each do |choice|
    #       files = manifest[choice.to_sym]&.keys&.map(&:to_s)&.reject { |f|
    #         f.chars.first.eql?('-')
    #       }
    #       a.concat(files) if files
    #     end
    #   end
    # end

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
