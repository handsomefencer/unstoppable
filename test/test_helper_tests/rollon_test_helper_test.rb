# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::RollonTestHelper do
  Given(:subject) { RollonTestHelper.new(dir, options) }
  Given(:troot) { Roro::CLI.test_root }
  Given(:choices) { ['stacks', css_flavor, "sqlite", js_flavor, "okonomi"] }
  Given(:story_root) { "#{troot}/fixtures/files/test_stacks/foxtrot" }
  Given(:story_path) { choices.join('/') }
  Given(:dir) { "#{story_root}/#{story_path}" }
  Given(:options) { { rollon_dummies: false } }
  Given(:asserted_file) { :"app/assets/stylesheets/application.tailwind.css" }
  Given(:refuted_file) { :"app/assets/stylesheets/application.tailwind.css!" }
  Given(:stackfile_strings) { :"mise/containers/app/env/base.env" }
  Given(:stackfile_hashes) { :"docker-compose.development.yml" }
  Given(:css_flavor) { 'bootstrap' }
  Given(:js_flavor) { 'bun' }

  describe '#initialize' do
    Given(:assert_correct_variables) do
      assert_equal story_root, subject.story_root
      assert_equal story_path, subject.story_path
      assert_equal dir, subject.dir
    end

    describe 'when stack is the active stack' do
      Given(:story_root) { "#{troot}/roro" }
      Then { assert_correct_variables }
    end

    describe 'when stack is a fixture stack' do
      Then { assert_correct_variables }
    end

    describe 'when debugger not specified' do
      Then { refute subject.rollon_dummies }
      And { refute subject.rollon_loud }
    end

    describe 'when debugger false' do
      Given(:options) { { debuggerer: false } }
      Then { refute subject.rollon_dummies }
      And { refute subject.rollon_loud }
    end

    describe 'when debugger true' do
      Given(:options) { { debuggerer: true } }
      Then { assert subject.rollon_dummies }
      And { assert subject.rollon_loud }
    end
  end

  describe '#choices' do
    Given(:expected) { %w[stacks bootstrap sqlite bun okonomi] }
    Then { assert_equal expected, subject.choices }
  end

  describe '#answers' do
    Then { assert_equal [1,4,1,1], subject.answers }
  end

  describe '#manifests' do
    Given { skip }
    describe 'when one manifest in brach -- bootstrap, bun' do
      Then do
        assert_equal 1, subject.manifests.size
        assert_match /stacks\/_manifest.yml/, subject.manifests.first
      end
    end

    describe 'when three manifests in branch -- tailwind, bun' do
      Given(:css_flavor) { 'tailwind' }
      Then do
        assert_equal 2, subject.manifests.size
        assert_match /stacks\/_manifest.yml/, subject.manifests[0]
        assert_match /tailwind\/_manifest.yml/, subject.manifests[1]
      end

      describe 'when three manifests in branch -- tailwind, importmaps' do
        Given(:js_flavor) { 'importmaps' }
        Then do
          assert_equal 3, subject.manifests.size
          assert_match /stacks\/_manifest.yml/, subject.manifests[0]
          assert_match /tailwind\/_manifest.yml/, subject.manifests[1]
          assert_match /importmaps\/_manifest.yml/, subject.manifests[2]
        end
      end
    end
  end

  describe '#manifest_for_story(*choices)' do
    Given(:result) { subject.manifest_for_story }
    Given(:contents) { result[stackfile_strings] }
    Given(:svcs) { result[stackfile_hashes][:services] }

    describe 'when evaluating for file existence' do

      describe 'when file asserted' do
        Then do
          assert_equal 3, result.keys.size
          assert_equal stackfile_hashes, result.keys[0]
          assert_equal asserted_file, result.keys[1]
          assert_equal stackfile_strings, result.keys[2]
        end

        describe 'and then refuted' do
          Given(:css_flavor) { 'tailwind' }
          Then do
            assert_equal 4, result.keys.size
            assert_equal stackfile_hashes, result.keys[0]
            assert_equal stackfile_strings, result.keys[1]
            assert_equal refuted_file, result.keys[2]
            assert_match /development\.env/, result.keys[3]
          end

          describe 'and then asserted' do
            Given(:js_flavor) { 'importmaps' }
            Given { skip }
            Then do
              assert_equal 4, result.keys.size
              assert_equal stackfile_hashes, result.keys[0]
              assert_equal stackfile_strings, result.keys[1]
              assert_match /development\.env/, result.keys[2]
              assert_equal asserted_file, result.keys[3]
            end
          end
        end
      end
    end

    describe 'when evaluating file contents' do

      describe 'When item is a string' do
        Then do
          assert_equal 1, subject.manifests.size
          assert_equal 3, contents.size
          assert_equal "/FOO=foo/", contents[0]
          assert_equal "/BAR=bar/", contents[1]
          assert_equal "/BAZ=baz/!", contents[2]
        end

        describe 'when overridden and BAR refuted and BAZ asserted' do
          Given(:css_flavor) { 'tailwind' }
          Then do
            assert_equal 3, contents.size
            assert_equal "/FOO=foo/", contents[0]
            assert_equal "/BAR=bar/!", contents[1]
            assert_equal "/BAZ=baz/", contents[2]
          end

          describe 'then BAR asserted and FOO refuted' do
            Given(:js_flavor) { 'importmaps' }
            Then do
              assert_equal 4, subject.manifests.size
              assert_includes contents, "/FOO=foo/!"
              assert_includes contents, "/BAZ=baz/"
              assert_includes contents, "/BAR=bar/"
            end
          end
        end
      end

      describe 'When item is a hash' do
        Then do
          assert_equal 1, subject.manifests.size
          assert_equal 'dev', svcs.dig(:dev, :container_name)
        end
      end

      describe 'when hash assertion added downstream' do
        Given(:css_flavor) { 'tailwind' }
        Then do
          assert_equal 3, subject.manifests.size
          assert_equal 3, svcs.keys.size
          assert_includes svcs.keys, :dev
          assert_includes svcs.keys, :"watch-css"
          assert_includes svcs.keys, :"watch-js"
        end
      end

      describe 'when hash refutation added downstream' do
        Given(:css_flavor) { 'tailwind' }
        Given(:js_flavor) { 'importmaps' }
        Then do
          assert_equal 4, subject.manifests.size
          assert_equal 3, svcs.keys.size
          assert_includes svcs.keys, :dev
          assert_includes svcs.keys, :"watch-css"
          assert_includes svcs.keys, :"watch-js!"
          assert_includes svcs.dig(:dev, :container_name), 'dev'
        end
      end
    end
  end

  describe '#collect_dummies' do
    Given { skip }
    describe 'when all files asserted' do

      Then do
        assert_equal 3, subject.dummies.size
        assert_includes subject.dummies, stackfile_strings.to_s
        assert_includes subject.dummies, stackfile_hashes.to_s
        assert_includes subject.dummies, asserted_file.to_s
        refute_includes subject.dummies, refuted_file.to_s
      end
    end

    describe 'When one file refuted' do
      Given(:css_flavor) { 'tailwind' }
      Then do
        assert_equal 3, subject.dummies.size
        assert_includes subject.dummies, stackfile_strings.to_s
        assert_includes subject.dummies, stackfile_hashes.to_s
        refute_includes subject.dummies, refuted_file.to_s
        refute_includes subject.dummies, asserted_file.to_s
      end
    end
  end

  describe '#rollon' do
    Given { skip }
    Given(:workbench) {}
    Given(:options) { { rollon_dummies: true, rollon_loud: true } }
    Given(:execute) { subject.rollon }

    describe 'when rollon_dummies: false must raise error' do
      Given(:dummy_dir) { "#{subject.dir}/dummy"}
      Given { FileUtils.remove_dir(dummy_dir) if File.exist?(dummy_dir) }
      Given(:options) { { rollon_dummies: false} }
      Then { assert_raises(RuntimeError) { execute } }
    end

    describe 'when rollon_dummies: true' do
      describe 'must capture dummy files' do
        Given { execute }
        Then { refute_match /usr\/src/, Dir.pwd }
        And { assert_match 'workbench', Dir.pwd }
        And { assert glob_dir('/**/*Gemfile').first }

        describe 'when dummies captured and rollon_dummies: false' do
          Given(:options) { { rollon_dummies: true } }
          Given { execute }
          Then { assert glob_dir('/**/*Gemfile').first }
        end
      end
    end
  end
end
