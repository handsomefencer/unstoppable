# frozen_string_literal: true

module Minitest
  class Spec
    before do
      if defined? workbench
        prepare_destination(*workbench)
        Dir.chdir("#{@tmpdir}/workbench")
        @tmpdir_glob = Dir.glob("#{@tmpdir}/workbench/**/*")
      end
    end

    def assert_valid_catalog(catalog)
      lambda do |node|
        catalog = "#{catalog_root}/#{node}"
        validate = validator.validate_catalog(catalog)
        assert_nil validate
      end
    end

    def file_match_in_files?(file_matcher, files)
      files.any? {|file| file.match file_matcher }
    end

    def assert_file_match_in(file_matcher, files)
      assert file_match_in_files?(file_matcher, files),
        "'...#{file_matcher}' doesn't match any files in: #{files}"
    end

    def assert_asked(prompt, choices, answer)
      Thor::Shell::Basic.any_instance
        .stubs(:ask)
        .with(prompt, {:limited_to => choices.keys.map(&:to_s) })
        .returns(choices[answer])
    end

    def stubs_yes?(answer = 'yes')
      Thor::Shell::Basic.any_instance
                        .stubs(:yes?)
                        .returns(answer)
    end
    def stubs_answer(answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .returns(answer)
    end

    def stubs_itinerary(itinerary = nil)
      Roro::Configurators::Configurator
        .any_instance
        .stubs(:itinerary)
        .returns(itinerary.map {|i| "#{Dir.pwd}/lib/roro/catalog/#{i}"})
    end

    def stubs_manifest(manifest = nil )
      Roro::Configurators::Configurator
        .any_instance
        .stubs(:manifest)
        .returns(manifest.map {|i| "#{Dir.pwd}/lib/roro/catalog/#{i}"})
    end



    def prepare_destination(*workbench)
      @tmpdir = Dir.mktmpdir
      FileUtils.mkdir_p("#{@tmpdir}/workbench")
      workbench.each do |dummy_app|
        source = Dir.pwd + "/test/dummies/#{dummy_app}"
        if File.exist?(source)
          FileUtils.cp_r(source, "#{@tmpdir}/workbench")
        else
          FileUtils.mkdir_p("#{@tmpdir}/workbench/#{dummy_app}")
        end
      end
    end

    def catalog_path(args = nil )
      append = defined?(catalog) ? "/#{catalog}" : nil
      prepend_valid = args.eql?(:invalid) ? 'invalid' : 'valid'
      fixture_path = "#{Dir.pwd}/test/fixtures"
      catalog_root ||= "#{fixture_path}/stacks/#{prepend_valid}/stacks"
      "#{catalog_root}#{append}"
    end

    after do
      Dir.chdir ENV['PWD'] if defined? workbench
    end
  end
end
