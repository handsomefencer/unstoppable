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

    def assert_itinerary_in(matchers, itineraries)
      is_present = itineraries.any? do |itinerary|
        matches = []
        matchers.each do |matcher|
          matches << matcher if file_match_in_files?(matcher, itinerary)
        end
        true if matches.size.eql?(matchers.size)
      end
      assert is_present, "'...#{matchers}' not found in itineraries: #{itineraries}"
    end

    def assert_asked(prompt, choices, answer)
      Thor::Shell::Basic.any_instance
        .stubs(:ask)
        .with(prompt, {:limited_to => choices.keys.map(&:to_s) })
        .returns(choices[answer])
    end

    def stubs_answer(answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .returns(answer)
    end

    def assert_question_asked(*question, answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .with(*question)
                        .returns(answer)
    end

    def stubs_itinerary(itinerary = nil )
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

    def assert_inflections(inflections)
      inflections.each { |item|
        inflection_path = "#{catalog_path}#{"/#{item[0]}" unless item[0].nil?}"
        builder = QuestionBuilder.new(inflection: inflection_path)
        question = builder.question
        inflection_options = builder.inflection_options
        assert_question_asked(question, inflection_options.key(item[1])) }
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

    after do
      Dir.chdir ENV['PWD'] if defined? workbench
    end
  end
end
