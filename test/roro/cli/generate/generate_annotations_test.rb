# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_annotations' do
  Given(:subject)     { Roro::CLI.new }
  Given(:workbench)   { 'test_annotate/lib' }
  Given(:base)        { 'lib/roro/stacks/unstoppable_developer_styles' }
  Given(:space)       { "#{base}/okonomi/languages/ruby/frameworks/rails" }
  Given(:file)        { "#{space}/versions/v6_1/test/0/_test.rb" }
  Given(:story_path)        { "#{space}/versions/v6_1" }
  Given(:description) { 'adventure::rails-v6_1::0 sqlite & ruby-v2_7' }
  Given(:expected) { /describe 'adventure::rails-v6_1::0 sqlite & ruby-v2_7'/ }
  Given(:adventure_test) { file }
  Given(:dummy) { "#{story_path}/test/0/dummy/idiot.yaml" }

  Given { subject.generate_annotations }

  describe 'after generate' do
    Then  { assert_file file, expected }
  end

  # def adventure_test_files
  #   Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
  #      .map {|f| f.split("#{Dir.pwd}/").last }
  # end


  describe '#describe_block_for(dummy)' do
    Given(:dummies) { subject.dummies_for(file) }
    Given(:dummy) { dummies.first }
    # Then { assert_equal 'blah', subject.describe_block_for(dummy) }
  end

  describe 'description blocks' do
    describe 'outmost' do
      Then { assert_match description, subject.describe_outmost(description) }

      describe '#describe_outer_before_actions' do
        # Then { assert_match description, subject.describe_before_actions(file) }

        describe 'inner' do
          # Then { assert_match description, subject.describe_outmost(description) }
        end
      end
    end

    describe 'after_actions' do
      # Then { assert_match description, subject.describe_after_actions(file) }
    end

    describe '#dummy_fille_with' do
      Given(:dummy) { "#{space}/versions/v6_1/test/0/dummy/idiot.yml" }
      # Then { assert_match 'blah', subject.describe_dummy_file_with(dummy) }
    end

    describe '#description_helper(adventure_test)' do
      # Given(:result) { subject.description_helper('adventure_test') }

      # Then { assert_match "describe 'idiot.yml'", result }
      # Then { save_output(result) }
    end
    describe '#describe_dummy_file' do
      Given(:result) { subject.describe_dummy_file('idiot.yml') }

      # Then { assert_match "describe 'idiot.yml'", result }
      # Then { save_output(result) }
    end

    describe '#dummy_assertions' do
      Given(:result) { subject.dummy_assertions('idiot.yml') }

      Then { assert_includes result, "  Given(:file) { 'idiot.yml' }" }
      # And { save_output(result) }
    end

    describe '#dummy_assert_file' do
      Given(:result) { subject.dummy_assert_file('idiot.yml') }
      Then { assert_includes result, "  Then { assert_file 'idiot.yml' }" }
    end

    def save_output(result)
      File.open("#{@roro_dir}/tmp/blah.rb", "w") do |f|
        f.write(result)
      end
    end

    describe '#dummy_assert_contents' do
      Given(:result) { subject.dummy_assert_file('idiot.yml') }
      Then { assert_includes result, "  Then { assert_file 'idiot.yml' }" }
    end

    describe '#dummies_for(adventure_test)' do
      Given(:result) { subject.dummies_for(adventure_test) }
      Then { assert_includes result, dummy }
    end

    describe '#dummy_path_for(adventure_test)' do
      Given(:result) { subject.dummy_path_for(adventure_test) }
      Then { assert_match 'test/0/dummy', result }
      And  { refute_match 'test/dummy/', result }
    end

    describe '#story_path_for(adventure_test)' do
      Given(:result) { subject.story_path_for(adventure_test) }
      Then { assert_match "versions/v6_1", result }
      And  { refute_match "versions/v6_1/", result }
    end

    describe '#adventure_test_files' do
      Then { assert_includes subject.adventure_test_files, adventure_test }
    end
  end
end
