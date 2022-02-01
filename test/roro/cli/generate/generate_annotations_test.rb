# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_annotations' do
  Given(:subject)        { Roro::CLI.new }
  Given(:workbench)      { 'test_annotate/lib' }
  Given(:base)           { 'lib/roro/stacks/unstoppable_developer_styles' }
  Given(:space)          { "#{base}/okonomi/languages/ruby/frameworks/rails" }
  Given(:file)           { "#{space}/versions/v6_1/test/0/_test.rb"}

  Given(:expected) { /describe 'adventure::rails-v6_1::0 sqlite & ruby-v2_7'/ }

  Given { subject.generate_annotations }

  describe 'after generate' do
    Then  { assert_file file, expected }
  end
end
