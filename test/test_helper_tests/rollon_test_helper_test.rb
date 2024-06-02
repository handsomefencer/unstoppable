# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::RollonTestHelper do

  Given(:story_root) { "#{Roro::CLI.test_root}/fixtures/files/test_stacks/foxtrot" }

  Given(:css_processor) { 'bootstrap' }
  Given(:js_watcher) { 'bun' }
  Given(:choices) { ['stacks', css_processor, "sqlite", js_watcher, "okonomi"] }

  Given(:story_path) { choices.join('/') }
  Given(:options) { { rollon_dummies: false } }
  Given(:subject) { RollonTestHelper.new("#{story_root}/#{story_path}", options) }

  describe '#initialize' do
    Given(:assert_correct_variables) do
      assert_equal story_root, subject.story_root
      assert_equal story_path, subject.story_path
      assert_equal "#{story_root}/#{story_path}", subject.dir
    end

    describe 'when stack is the active stack' do
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
      Then { assert_correct_variables }
    end

    describe 'when stack is a fixture stack' do
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
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
    describe 'when one manifest in story' do
      Then do
        assert_equal 1, subject.manifests.size
        assert_match /stacks\/_manifest.yml/, subject.manifests.first
      end
    end

    describe 'when two manifests in story' do
      Given(:css_processor) { 'tailwind' }
      Given(:js_watcher) { 'bun' }
      Then do
        assert_equal 4, subject.manifests.size
        assert_match /stacks\/_manifest.yml/, subject.manifests[0]
        assert_match /tailwind\/_manifest.yml/, subject.manifests[1]
        assert_match /sqlite\/_manifest.yml/, subject.manifests[2]
        assert_match /bun\/_manifest.yml/, subject.manifests[3]
      end
    end

    describe 'when three manifests in story' do
      Given(:css_processor) { 'tailwind' }
      Given(:js_watcher) { 'importmaps' }
      Then do
        assert_equal 4, subject.manifests.size
        assert_match /stacks\/_manifest.yml/, subject.manifests[0]
        assert_match /tailwind\/_manifest.yml/, subject.manifests[1]
        assert_match /sqlite\/_manifest.yml/, subject.manifests[2]
        assert_match /importmaps\/_manifest.yml/, subject.manifests[3]
      end
    end
  end

  describe '#manifest_for_story(*choices)' do
    Given(:excluded_file) { :"app/assets/stylesheets/application.tailwind.css!" }
    Given(:included_file) { :"app/assets/stylesheets/application.tailwind.css" }

    Given(:css_processor) { 'bootstrap' }
    Given(:js_watcher) { 'bun' }
    Given(:choices) { ['stacks', css_processor, "sqlite", js_watcher, "okonomi"] }
    Given(:stack_file) { :".gitignore" }
    Given(:stack_file_refuted) { :".gitignore!" }
    Given(:stack_file_with_string) { :"mise/containers/app/env/base.env" }
    Given(:stack_file_with_yaml) { :"docker-compose.development.yml" }
    Given(:asserted_file) { :"app/assets/stylesheets/application.tailwind.css" }
    Given(:refuted_file) { :"app/assets/stylesheets/application.tailwind.css!" }
    Given(:result) { subject.manifest_for_story(*choices) }

    describe 'when file asserted' do
      focus
      Then do
        assert_equal 3, result.keys.size
        assert_equal :'.gitignore', result.keys[0]
        assert_equal asserted_file, result.keys[1]
      end
    end

    describe 'when file asserted, refuted' do
      Given(:css_processor) { 'tailwind' }
      Given(:js_watcher) { 'bun' }
      focus
      Then do
        assert_equal 3, result.keys.size
        assert_equal :'.gitignore', result.keys[0]
        assert_equal refuted_file, result.keys[2]
      end
    end

    describe 'when file asserted, refuted, asserted' do
      Given(:css_processor) { 'tailwind' }
      Given(:js_watcher) { 'importmaps' }
      focus
      Then do
        assert_equal 3, result.keys.size
        assert_equal :'.gitignore', result.keys[0]
        assert_equal asserted_file, result.keys[2]
      end
    end

    describe 'when file with array contents asserted' do
      Given(:stack_file_with_string) { :"mise/containers/app/env/base.env" }
      Given(:contents) { result[stack_file_with_string] }
      focus
      Then do
        assert_equal 1, contents.size
        assert_match /PARALLEL_WORKERS/, contents[0]
      end

      describe 'when contents added to file array downstream' do
        Given(:css_processor) { 'tailwind' }
        Given(:js_watcher) { 'bun' }
        Given(:stack_file_with_string) { :"mise/containers/app/env/base.env" }
        Given(:contents) { result[stack_file_with_string] }
        focus
        Then do
          assert_equal 2, contents.size
          assert_match /PARALLEL_WORKERS/, contents[0]
          assert_match /PERPENDICULAR_WORKERS/, contents[1]
        end
      end
    end

    # describe 'when file asserted, refuted' do
    #   Given(:css_processor) { 'tailwind' }
    #   Given(:js_watcher) { 'bun' }
    #   focus
    #   Then do
    #     assert_equal 3, result.keys.size
    #     assert_equal :'.gitignore', result.keys[0]
    #     assert_equal refuted_file, result.keys[2]
    #   end
    # end

#     describe 'when file asserted, refuted, asserted' do
#       Given(:css_processor) { 'tailwind' }
#       Given(:js_watcher) { 'importmaps' }
# focus
#       Then do
#         assert_equal 3, result.keys.size
#         assert_equal :'.gitignore', result.keys[0]
#         assert_equal asserted_file, result.keys[2]
#       end
#     end
  end


  # describe '#manifest_for(*choices)' do
  #   Given { skip }

  #   Given(:result) { subject.manifest_for(*choices) }

  #   describe 'when file is included' do
  #     Then do
  #       assert_includes result.keys, :".gitignore"
  #       assert_nil result.dig(:".gitignore")
  #     end
  #   end

  #   describe 'when file is excluded' do
  #     Then { assert_includes result.keys, excluded_file }
  #   end

  #   describe 'when file included with included content' do
  #     Then do
  #       assert_includes result.keys, stack_file_with_string
  #       assert_match "PARALLEL", result.dig(stack_file_with_string, 0)
  #     end
  #   end

  #   describe 'when file included with excluded content' do
  #     Then do
  #       assert_includes result.keys, stack_file_with_string
  #       assert_match "/EXCLUDED=nil/ !", result.dig(stack_file_with_string, 1)
  #       assert_match "/PARALLEL_WORKERS=4/", result.dig(stack_file_with_string, 0)
  #     end
  #   end

  #   describe 'when overriden downstream' do
  #     Given(:css_processor) { 'tailwind' }
  #     Given(:js_watcher) { 'bun' }

  #     describe 'when file included but excluded downstream' do
  #       Then { assert_includes result.keys, excluded_file }
  #       And { refute_includes result.keys, included_file }
  #     end

  #     describe 'when file excluded but included downstream' do
  #       Given(:js_watcher) { 'importmaps' }
  #       Then { assert_includes result.keys, included_file }
  #       And { refute_includes result.keys, excluded_file }
  #     end

  #     describe 'when file contents overriden downstream' do
  #         # Then { assert_equal "watch-child-override", result  }
  #     end
  #   end
  # end

  describe '#collect_dummies' do
    Then { assert_includes subject.dummies, 'docker-compose.development.yml' }
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
