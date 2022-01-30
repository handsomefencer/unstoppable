# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_annotations' do
  Given(:subject)        { Roro::CLI.new }
  Given(:workbench)      { 'test_annotate/lib' }
  Given(:base)           { 'lib/roro/stacks/unstoppable_developer_styles' }
  Given(:space)          { "#{base}/okonomi/languages/ruby/frameworks/rails" }
  Given(:file)           { "#{space}/versions/v6_1/test/0/_test.rb"}

  Given(:assert_content) { -> (c) { assert_file( file, /#{c}/ )} }

  Given(:blocktext) do
    <<~HEREDOC
    describe 'adventure::rails_v6_1::0::sqlite & ruby_v2_7' do
      Given(:workbench)  { }
      Given { @rollon_loud    = true }
      Given { @rollon_dummies = false }
      Given { rollon(__dir__) }
    
      describe
    HEREDOC
  end

  Given { subject.generate_annotations }

  describe 'after generate' do
    focus
    Then  { assert_content[blocktext] }
  end

  describe '#adventure_test_files' do
    Then { assert_includes subject.adventure_test_files, file, expected }
  end

  describe '#adventure_description(stack)' do
    Then { assert_match subject.adventure_description(file), expected }
  end
end
